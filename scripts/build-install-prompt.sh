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
これは開発の依頼ではなく、道具の組み込みと、その道具での聞き取りの依頼です。
下の【ファイル1】〜【ファイル4】は、私が用意した中身です。インターネットから取り寄せる必要はありません。

0. 最初に「これから、ファイルの保存の許可を求める画面が出ます。保存先は .claude/skills/、報告書の置き場所の docs/reports/、git を使っている場合は .gitignore です。この作業ではどこにも送信しません。それ以外の場所への保存や、送信を求められたら『拒否』を押してください」と私に伝えてください。
1. 【ファイル1】〜【ファイル4】を、中身を1文字も変えずに、この作業フォルダの次の場所に保存してください。
   - 【ファイル1】→ .claude/skills/kikitori/SKILL.md
   - 【ファイル2】→ .claude/skills/kikitori/REPORT-FORMAT.md
   - 【ファイル3】→ .claude/skills/grilling/SKILL.md
   - 【ファイル4】→ .claude/skills/kikitori/GRILLING-LICENSE（grilling の作者のライセンス表示）
   同じ場所にすでにファイルがあり、中身が同じなら、そのままにしてください。.claude/skills/grilling/SKILL.md がすでにあって中身が違う場合は、上書きせず、すでにあるものを使ってください。.claude/skills/kikitori/ のファイルの中身が違う場合は、上書きしてよいか私に聞いてください。
2. 記録（git commit）も送信（push）もしないでください。保存するだけです。この作業フォルダが git の置き場所なら、`.gitignore` に `docs/reports/` の1行を足してください（無ければ作り、すでにあれば足さない。改行で終わっていなければ先に改行を足す）。報告書が誤って送られないようにするためです。
3. 保存できたら、.claude/skills/kikitori/SKILL.md の手順どおりに、すぐ聞き取りを始めてください。
4. 最後に、次回からの始め方を一言伝えてください。自分のパソコンの作業フォルダなら「次回もこの作業フォルダを開いて /kikitori と送るだけで始まります」。クラウドの作業環境（claude.ai/code など）なら「この作業環境を閉じると道具も消えます。次回もこの文章を貼ってください」。
EOF
  emit "ファイル1" "$root/.claude/skills/kikitori/SKILL.md"
  emit "ファイル2" "$root/.claude/skills/kikitori/REPORT-FORMAT.md"
  emit "ファイル3" "$root/.claude/skills/grilling/SKILL.md"
  emit "ファイル4" "$root/licenses/mattpocock-skills-LICENSE"
} > "$out"
echo "kit/install-prompt.md を作りました（$(wc -c < "$out") バイト）"
