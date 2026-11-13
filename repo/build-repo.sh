#!/usr/bin/env bash
# Builds every package listed in repo/packages.txt and assembles the
# `horyos` pacman repository in repo/out/x86_64.
#
# Usage: ./repo/build-repo.sh [workdir]
set -euo pipefail

REPO_NAME=horyos
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK="${1:-$ROOT/.work}"
OUT="$ROOT/repo/out/x86_64"
PACKAGES="$ROOT/repo/packages.txt"

mkdir -p "$WORK" "$OUT"

while read -r name url subdir; do
    [[ -z "${name:-}" || "$name" == \#* ]] && continue
    echo "==> $name"
    src="$WORK/$name"
    if [[ ! -d "$src" ]]; then
        git clone --depth 1 "$url" "$src"
    else
        git -C "$src" pull --ff-only
    fi
    build="$WORK/build-$name"
    rm -rf "$build"
    mkdir -p "$build"
    cp -r "$src/$subdir/." "$build/"
    (cd "$build" && makepkg -sf --noconfirm)
    cp "$build"/*.pkg.tar.* "$OUT/"
done < "$PACKAGES"

repo-add "$OUT/$REPO_NAME.db.tar.gz" "$OUT"/*.pkg.tar.*
ln -sf "$REPO_NAME.db.tar.gz" "$OUT/$REPO_NAME.db"
ln -sf "$REPO_NAME.files.tar.gz" "$OUT/$REPO_NAME.files"
echo "==> repo ready at $OUT"
