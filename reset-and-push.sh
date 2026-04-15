#!/bin/bash
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
TOKEN="DEIN_GITHUB_TOKEN"
USER="fakebrunzen"
REPO="marokko-2026"

echo "Schritt 1: fotos/ aus git entfernen..."
git -C "$DIR" rm -r --cached fotos/ 2>/dev/null || true
echo "fotos/" >> "$DIR/.gitignore"

echo "Schritt 2: Neue saubere History aufbauen..."
git -C "$DIR" checkout --orphan fresh-start
git -C "$DIR" add marokko-reise-2026.html index.html fotos_web/ .gitignore github-update.sh github-setup.sh reset-and-push.sh
git -C "$DIR" commit -m "Marokko 2026 - Reiseuebersicht mit Fotogalerie"

git -C "$DIR" branch -D main 2>/dev/null || true
git -C "$DIR" branch -m main

echo "Schritt 3: Force push zu GitHub (~121 MB)..."
git -C "$DIR" remote set-url origin "https://${USER}:${TOKEN}@github.com/${USER}/${REPO}.git"
git -C "$DIR" push --force origin main

echo ""
echo "Fertig! Seite online unter: https://${USER}.github.io/${REPO}/"
echo "(GitHub Pages braucht ~30 Sekunden zum Aktualisieren)"
