```rust
use std::collections::{HashMap, HashSet, VecDeque};
use std::path::{Path, PathBuf};
use std::sync::{Arc, RwLock};
use std::time::{Duration, Instant};
use std::thread;
use std::fs;

use notify::{Watcher, RecursiveMode, Event, EventKind};
use rusqlite::{Connection, params, Result as SqlResult};
use serde::{Serialize, Deserialize};
use tokio::sync::mpsc;
use axum::{Router, Json, extract::Query as AxumQuery};
use axum::routing::{get, post};
use tower::ServiceBuilder;
use tower_http::compression::CompressionLayer;

// Core type definitions
type SigHash = u64;
type NodeId = u64;
type EdgeId = (NodeId, NodeId);

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
enum NodeKind {
    Trait,
    Struct,
    Function,
    Method,
    Module,
    Type,
    Constant,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
enum EdgeKind {
    Impl,
    Calls,
    Uses,
    Contains,
    Depends,
    Extends,
    Returns,
    Accepts,
    Mutates,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct Node {
    id: NodeId,
    sig_hash: SigHash,
    kind: NodeKind,
    name: String,
    full_signature: String,
    file_path: PathBuf,
    line_start: u32,
    line_end: u32,
    visibility: String,
    metadata: HashMap<String, String>,
}

impl Node {
    fn new(
        id: NodeId,
        kind: NodeKind,
        name: String,
        full_signature: String,
        file_path: PathBuf,
        line_start: u32,
        line_end: u32,
    ) -> Self {
        let sig_hash = Self::compute_hash(&full_signature);
        Self {
            id,
            sig_hash,
            kind,
            name,
            full_signature,
            file_path,
            line_start,
            line_end,
            visibility: String::from("private"),
            metadata: HashMap::new(),
        }
    }

    fn compute_hash(signature: &str) -> SigHash {
        use std::hash::{Hash, Hasher};
        let mut hasher = std::collections::hash_map::DefaultHasher::new();
        signature.hash(&mut hasher);
        hasher.finish()
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct Edge {
    source: NodeId,
    target: NodeId,
    kind: EdgeKind,
    weight: f32,
    metadata: HashMap<String, String>,
}

impl Edge {
    fn new(source: NodeId, target: NodeId, kind: EdgeKind) -> Self {
        Self {
            source,
            target,
            kind,
            weight: 1.0,
            metadata: HashMap::new(),
        }
    }
}

#[derive(Debug, Clone)]
struct InterfaceGraph {
    nodes: HashMap<NodeId, Arc<Node>>,
    edges: HashMap<EdgeId, Arc<Edge>>,
    forward_index: HashMap<NodeId, HashSet<NodeId>>,
    reverse_index: HashMap<NodeId, HashSet<NodeId>>,
    sig_hash_index: HashMap<SigHash, NodeId>,
}

impl InterfaceGraph {
    fn new() -> Self {
        Self {
            nodes: HashMap::new(),
            edges: HashMap::new(),
            forward_index: HashMap::new(),
            reverse_index: HashMap::new(),
            sig_hash_index: HashMap::new(),
        }
    }

    fn add_node(&mut self, node: Node) {
        let node_id =