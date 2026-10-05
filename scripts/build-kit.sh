#!/bin/sh
# 配布用フォルダ（kit/kikitori-kit）に最新の手順書を入れ、dist/kikitori-kit.zip を作り直す。
# 手順書を直したら必ず流す: sh scripts/build-kit.sh
set -eu
root=$(cd "$(dirname "$0")/.." && pwd)
kit="$root/kit/kikitori-kit"
rm -rf "$kit/.claude"
mkdir -p "$kit/.claude/skills"
cp -R "$root/.claude/skills/kikitori" "$kit/.claude/skills/kikitori"
rm -f "$kit/.claude/skills/kikitori/example-report.md"
# 聞き取りの肝の grilling（mattpocock/skills, MIT）は、書き換えずにそのまま同梱する
cp -R "$root/.claude/skills/grilling" "$kit/.claude/skills/grilling"
cp "$root/licenses/mattpocock-skills-LICENSE" "$kit/.claude/skills/grilling/LICENSE"
mkdir -p "$root/dist"
rm -f "$root/dist/kikitori-kit.zip"
cd "$root/kit"
# 日付を固定して、中身が同じなら同じ zip になるようにする
find kikitori-kit -exec touch -t 202601010000 {} +
zip -qrX "$root/dist/kikitori-kit.zip" kikitori-kit
echo "dist/kikitori-kit.zip を作りました"
