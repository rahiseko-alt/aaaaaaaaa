#!/bin/sh
# お客様に1回貼ってもらう文章（kit/install-prompt.md）を、手順書の中身から作り直す。
# 外からの取り寄せを使わず、必要なファイルの中身をすべて文章に入れる。
# 手順書を直したら必ず流す: sh scripts/build-install-prompt.sh
set -eu
root=$(cd "$(dirname "$0")/.." && pwd)
out="$root/kit/install-prompt.md"

emit() { # $1 見出し, $2 元ファイル
  printf '\n【%s】\n````\n' "$1"
  cat "$2"
  printf '````\n'
}

{
  cat <<'EOF'
生命保険代理店の営業向けの「商談の聞き取りツール kikitori」を、この作業フォルダに組み込み、そのまま聞き取りを始めてください。
下の【ファイル1】〜【ファイル4】は、私が用意した中身です。インターネットから取り寄せる必要はありません。

1. 【ファイル1】〜【ファイル4】を、中身を1文字も変えずに、この作業フォルダの次の場所に保存してください。同じ名前のファイルがあれば上書きしてください。
   - 【ファイル1】→ .claude/skills/kikitori/SKILL.md
   - 【ファイル2】→ .claude/skills/kikitori/REPORT-FORMAT.md
   - 【ファイル3】→ .claude/skills/grilling/SKILL.md
   - 【ファイル4】→ .claude/skills/grilling/LICENSE
2. この作業フォルダが git の置き場所なら、この4つのファイルだけを記録して送信（push）してください。次回の作業でも残るようにするためです。
3. 保存できたら、.claude/skills/kikitori/SKILL.md の手順どおりに、すぐ聞き取りを始めてください。
4. 最後に「次回からは /kikitori と送るだけで始まります」と一言伝えてください。
EOF
  emit "ファイル1" "$root/.claude/skills/kikitori/SKILL.md"
  emit "ファイル2" "$root/.claude/skills/kikitori/REPORT-FORMAT.md"
  emit "ファイル3" "$root/.claude/skills/grilling/SKILL.md"
  emit "ファイル4" "$root/licenses/mattpocock-skills-LICENSE"
} > "$out"
echo "kit/install-prompt.md を作りました（$(wc -c < "$out") バイト）"
