
# Copy all json files with trunc 

``` bash

bash -c '
dest="/home/amuldotexe/Desktop/before-I-go/.github/JsonFiles202508"
user="${SUDO_USER:-$USER}"
mkdir -p "$dest"
declare -A seen
while IFS= read -r -d "" f; do
  [[ -r "$f" ]] || continue
  h=$(sha256sum -- "$f" | cut -d" " -f1) || continue
  [[ ${seen[$h]+x} ]] && continue
  seen[$h]=1
  base=$(basename -- "$f")
  ext="${base##*.}"
  name="${base%.*}"
  target="$dest/$base"
  [[ -e "$target" ]] && target="$dest/${name}__${h:0:12}.$ext"
  cp --preserve=timestamps -- "$f" "$target"
done < <(
  find / \( -path "$dest" -o -path "$dest/*" \) -prune -o \
           -type f \( -iname "*Rust*.md" -o -name "*trun*.json" \) -print0 2>/dev/null
)
chown -R "$user":"$user" "$dest"
'

```
# Copy unique content

``` bash 
bash -c '
src="/home/amuldotexe/Documents"
dest="/home/amuldotexe/Desktop/before-I-go/.github/JsonFiles202508"
mkdir -p "$dest"
ts=$(date +%Y%m%d_%H%M%S)
out="$dest/summary_${ts}_start.txt"

declare -A seen
tmpdir="$(mktemp -d)"
trap "rm -rf \"$tmpdir\"" EXIT

extract() {
  f="$1"
  ext="${f##*.}"
  case "${ext,,}" in
    docx)
      if command -v pandoc >/dev/null 2>&1; then
        pandoc -q --from=docx --to=plain -- "$f" 2>/dev/null
      elif command -v docx2txt >/dev/null 2>&1; then
        docx2txt "$f" - 2>/dev/null
      else
        unzip -p -- "$f" word/document.xml 2>/dev/null | sed "s/<[^>]*>/ /g"
      fi
      ;;
    json)
      if command -v jq >/dev/null 2>&1; then
        jq -r . -- "$f" 2>/dev/null || cat -- "$f"
      else
        cat -- "$f"
      fi
      ;;
    *)
      cat -- "$f"
      ;;
  esac | tr -d "\000"
}

{
  printf "# Consolidated text dump\n\n"
  printf "- Source: %s\n- Generated: %s\n\n" "$src" "$(date -Is)"
} > "$out"

count=0
skipped=0

while IFS= read -r -d "" f; do
  [[ -r "$f" ]] || { ((skipped++)); continue; }
  tmp="$tmpdir/part"
  if ! extract "$f" > "$tmp"; then ((skipped++)); continue; fi
  # Skip if only whitespace/newlines
  if ! grep -q "[^[:space:]]" "$tmp"; then ((skipped++)); continue; fi
  h=$(sha256sum -- "$tmp" | cut -d" " -f1) || { ((skipped++)); continue; }
  [[ ${seen[$h]+x} ]] && continue
  seen[$h]=1
  {
    printf "\n---\n\n### File: %s\n\n" "$f"
    cat -- "$tmp"
    printf "\n"
  } >> "$out"
  ((count++))
done < <(
  find "$src" \
    \( -path "$dest" -o -path "$dest/*" \) -prune -o \
    -type f \( -iname "*Rust*.md" -o -iname "*trun*.json" -o -iname "*.docx" \) -print0 2>/dev/null
)

{
  printf "\n---\n"
  printf "\n*Added %d unique text blocks; skipped %d files.*\n" "$count" "$skipped"
  printf "\n_Output file:_ %s\n" "$out"
} >> "$out"

printf "%s\n" "$out"
'
```