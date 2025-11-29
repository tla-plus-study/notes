#!/usr/bin/env bash
# scripts/new-week.sh
set -euo pipefail

# --- config & helpers --------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GIT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
WEEKS_DIR="${GIT_ROOT}/weeks"

TEMPLATE_DIR="$GIT_ROOT/templates"

TITLE=""        # optional custom title
DRY_RUN=0

usage() {
  cat <<USAGE
Usage: $(basename "$0") [-n "Custom Week Title"] [--dry-run]

Creates weeks/week-XX with:
  - notes.tex (LaTeX skeleton with \\today)
  - Makefile (links "$TEMPLATE_DIR/Makefile)
  - README.md (short log)
  - specs/ (empty dir)
USAGE
}

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--title) 
      TITLE="${2:-}"; 
      shift 2
      ;;
    --dry-run)  
      DRY_RUN=1; 
      shift
      ;;
    -h|--help)  
      usage
      exit 0
      ;;
    *) 
      wecho 
      "Unknown option: $1" >&2; usage; exit 1;;
  esac
done

mkdir -p "$WEEKS_DIR"

# --- compute next week number ------------------------------------------------
shopt -s nullglob
max_n=0
for d in "$WEEKS_DIR"/week-*; do
  [[ -d "$d" ]] || continue
  base="$(basename "$d")"
  if [[ "$base" =~ ^week-([0-9]+)$ ]]; then
    n="${BASH_REMATCH[1]}"
    (( n > max_n )) && max_n="$n"
  fi
done
next_n=$((max_n + 1))
next_pad=$(printf "%02d" "$next_n")
week_dir="$WEEKS_DIR/week-$next_pad"

[[ -z "$TITLE" ]] && TITLE="TLA+ Study Group — Week $next_pad"

# --- dry run preview ---------------------------------------------------------
if [[ "$DRY_RUN" -eq 1 ]]; then
  cat <<PREVIEW
Would create: $week_dir
  - $week_dir/notes.tex    (title: $TITLE)
  - $week_dir/Makefile     (includes ../../template/Makefile.common)
  - $week_dir/README.md
  - $week_dir/specs/
PREVIEW
  exit 0
fi

# --- create files ------------------------------------------------------------
mkdir -p "$week_dir"
cp "$(realpath --relative-to="$week_dir" "${TEMPLATE_DIR}/Makefile")" \
   "$week_dir/Makefile"


safe_title=$(printf '%s' "$TITLE" | sed 's/[&|\\]/\\&/g')
sed "s|\$TITLE|$safe_title|g" \
  "$TEMPLATE_DIR/notes.tex" \
  > "$week_dir/notes.tex"

# README.md
cat > "$week_dir/README.md" <<MD
# Week $next_pad

**What we checked:**
-

**Decisions / invariants that stuck:**
-

**Follow-ups:**
-
MD

# --- create per user data ----------------------------------------------------
#
# to add your custom template - add yourself to the people array
# create a $TEMPLATE_DIR/$name folder and put 
#  * Makefile (or just a symlink to the main one)
#  * notes.tex with a `$TITLE` variable -- it will get populated by the week
#    number -- same as the main tex file
people=(bartosz benetis wizzardich)
for p in ${people[@]}; do
  target="${week_dir}/${p}"
  mkdir -p "${target}"

  sed "s|\$TITLE|$safe_title|g" \
    "${TEMPLATE_DIR}/${p}/notes.tex" \
    > "${target}/notes.tex"

  cp "$(realpath --relative-to="${target}" "${TEMPLATE_DIR}/Makefile")" \
    "${target}/Makefile"
done

echo "Created $week_dir"
echo "Next steps:"
echo "  cd \"$week_dir\" && make" '# builds notes.pdf'
