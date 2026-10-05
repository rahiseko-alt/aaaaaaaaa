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

0. 最初に「これから、ファイルの保存と、記録・送信（git を使っている場合だけ）の許可を求める画面が出ます。保存先は .claude/skills/ と報告書の置き場所（docs/reports/）、git を使っている場合は .gitignore と .kikitori/ も加わります。この作業フォルダの決まりで書く記録（引き継ぎメモなど）の保存を求められることもあります。それ以外の場所や、意図しない送信なら『拒否』を押してください」と私に伝えてください。
1. 【ファイル1】〜【ファイル4】を、中身を1文字も変えずに、この作業フォルダの次の場所に保存してください。
   - 【ファイル1】→ .claude/skills/kikitori/SKILL.md
   - 【ファイル2】→ .claude/skills/kikitori/REPORT-FORMAT.md
   - 【ファイル3】→ .claude/skills/grilling/SKILL.md
   - 【ファイル4】→ .claude/skills/kikitori/GRILLING-LICENSE（grilling の作者のライセンス表示）
   同じ場所にすでにファイルがあり、中身が同じなら、そのままにしてください。.claude/skills/grilling/SKILL.md がすでにあって中身が違う場合は、上書きせず、すでにあるものを使ってください。.claude/skills/kikitori/ のファイルの中身が違う場合は、上書きしてよいか私に聞いてください。
2. この作業フォルダが git の置き場所なら、`.gitignore` に `.kikitori/` の1行を足し（無ければ作り、すでにあれば足さない。改行で終わっていなければ先に改行を足す）、保存したファイルと `.gitignore` を名指しで記録して（`git add -- <ファイル>` の後に `git commit -- <ファイル>`。`git add -A` や `git add .` は使わない）、送信（push）してください。記録の前に、ほかに記録待ちのファイルがあれば、止めて私に聞いてください。ほかのファイルは記録に含めないでください（この作業フォルダの決まりで書くことになっている記録があれば、それは決まりに従ってください）。送り先の枝は、この作業環境の決まりに従ってください。送信が断られたり失敗したりしたら、強制送信や別の枝への送信は試さず、送れなかったことを伝えて先へ進んでください。
3. 保存できたら、.claude/skills/kikitori/SKILL.md の手順どおりに、すぐ聞き取りを始めてください。
4. 最後に、次回からの始め方を一言伝えてください。送った枝がこの置き場所の既定の枝なら「次回もこの作業フォルダを開いて /kikitori と送るだけで始まります」。別の枝なら「この枝を本流に取り込むと、次回からこの作業フォルダで /kikitori と送るだけで始まります」。git が無ければ「次回もこのフォルダを開いて /kikitori と送るだけで始まります」。
EOF
  emit "ファイル1" "$root/.claude/skills/kikitori/SKILL.md"
  emit "ファイル2" "$root/.claude/skills/kikitori/REPORT-FORMAT.md"
  emit "ファイル3" "$root/.claude/skills/grilling/SKILL.md"
  emit "ファイル4" "$root/licenses/mattpocock-skills-LICENSE"
} > "$out"
echo "kit/install-prompt.md を作りました（$(wc -c < "$out") バイト）"
