# Create scripts/daily_check.sh: prints git status,
# rustc --version, cargo --version, docker --version, 
# lists all .md files in docs. chmod +x && run it

#!/bin/zsh

# daily_check.sh - prints git status; version of rust, cargo, and docker; and all markdown files in docs folder
# Written to be run from any directory -- script cd's to repo root first

cd "$(dirname "$0")/.." || exit 1

echo "==== git status ==="
git status
echo "==== rust version ==="
rustc --version
echo "==== cargo version ==="
cargo --version
echo "=== docker version ===" 
docker --version
echo "==== markdown files in docs ==="
ls docs/*.md

