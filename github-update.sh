#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  NACH JEDEM CLAUDE-UPDATE AUSFÜHREN – Änderungen pushen
#  Ausführen mit:  bash github-update.sh
# ═══════════════════════════════════════════════════════════════

set -e

TOKEN="DEIN_GITHUB_TOKEN"
USER="fakebrunzen"
REPO="marokko-2026"
DIR="$(cd "$(dirname "$0")" && pwd)"

# Sicherstellen, dass Remote den Token enthält
git -C "$DIR" remote set-url origin "https://${USER}:${TOKEN}@github.com/${USER}/${REPO}.git"

# Änderungen committen & pushen
TIMESTAMP=$(date "+%d.%m.%Y %H:%M")
git -C "$DIR" add marokko-reise-2026.html index.html fotos_web/
git -C "$DIR" commit -m "🔄 Update Reiseübersicht – ${TIMESTAMP}" 2>/dev/null || echo "ℹ️  Keine Änderungen seit letztem Push."
git -C "$DIR" push origin main

echo ""
echo "✅ Seite aktualisiert: https://${USER}.github.io/${REPO}/"
echo "   (GitHub Pages braucht ~30 Sekunden zum Aktualisieren)"
