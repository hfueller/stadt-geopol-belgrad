#!/bin/bash
# Quarto post-render: Änderungen committen und nach GitHub pushen.
# Abschalten für einen Lauf:  QUARTO_NO_PUSH=1 quarto render
[ -n "$QUARTO_NO_PUSH" ] && exit 0

cd "${QUARTO_PROJECT_DIR:-$(dirname "$0")/..}" || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

git add -A
if git diff --cached --quiet; then
  exit 0   # nichts geändert
fi

git commit -q -m "Render $(date '+%Y-%m-%d %H:%M')" || exit 0

# Push im Hintergrund, damit Render/Preview nicht blockiert;
# Ergebnis landet in .quarto/autopush.log (ist per .gitignore ausgeschlossen)
mkdir -p .quarto
( GIT_TERMINAL_PROMPT=0 git push -q origin HEAD >> .quarto/autopush.log 2>&1 \
    && echo "$(date '+%F %T') push ok" >> .quarto/autopush.log \
    || echo "$(date '+%F %T') push FEHLGESCHLAGEN" >> .quarto/autopush.log ) &
exit 0
