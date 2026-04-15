#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  EINMALIG AUSFÜHREN – Marokko Reise 2026 auf GitHub einrichten
#  Ausführen mit:  bash github-setup.sh
# ═══════════════════════════════════════════════════════════════

set -e

TOKEN="DEIN_GITHUB_TOKEN"
USER="fakebrunzen"
REPO="marokko-2026"
DIR="$(cd "$(dirname "$0")" && pwd)"

echo "📁 Arbeitsverzeichnis: $DIR"
echo ""

# 1. Git initialisieren (falls noch nicht vorhanden)
if [ ! -d "$DIR/.git" ]; then
  echo "🔧 Git initialisieren..."
  git -C "$DIR" init
  git -C "$DIR" config user.email "baurlebjorn@gmail.com"
  git -C "$DIR" config user.name "Björn Bäurle"
fi

# 2. Remote konfigurieren
echo "🔗 Remote konfigurieren..."
git -C "$DIR" remote remove origin 2>/dev/null || true
git -C "$DIR" remote add origin "https://${USER}:${TOKEN}@github.com/${USER}/${REPO}.git"

# 3. Branch auf main setzen
git -C "$DIR" checkout -b main 2>/dev/null || git -C "$DIR" checkout main

# 4. Bestehendes README holen und mergen
echo "⬇️  Bestehendes Repo holen..."
git -C "$DIR" fetch origin main 2>/dev/null || true
git -C "$DIR" merge --allow-unrelated-histories -m "Merge initial repo" origin/main 2>/dev/null || true

# 5. HTML-Datei committen & pushen
echo "📤 Dateien committen und pushen..."
git -C "$DIR" add marokko-reise-2026.html
git -C "$DIR" commit -m "✈️ Marokko Reise 2026 – Reiseübersicht hinzugefügt" 2>/dev/null || echo "(Nichts zu committen)"
git -C "$DIR" push -u origin main

# 6. GitHub Pages via API aktivieren
echo "🌐 GitHub Pages aktivieren..."
PAGES_RESPONSE=$(curl -s -X POST \
  -H "Authorization: token ${TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  -d '{"source":{"branch":"main","path":"/"}}' \
  "https://api.github.com/repos/${USER}/${REPO}/pages")

if echo "$PAGES_RESPONSE" | grep -q '"url"'; then
  echo "✅ GitHub Pages aktiviert!"
else
  # Eventuell schon aktiv – Update versuchen
  curl -s -X PUT \
    -H "Authorization: token ${TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    -d '{"source":{"branch":"main","path":"/"}}' \
    "https://api.github.com/repos/${USER}/${REPO}/pages" > /dev/null
  echo "✅ GitHub Pages aktualisiert!"
fi

echo ""
echo "════════════════════════════════════════════════"
echo "🎉 Fertig! Die Seite ist in ~1 Minute erreichbar:"
echo "   https://${USER}.github.io/${REPO}/"
echo ""
echo "Passwort: Baurle2026"
echo "════════════════════════════════════════════════"
