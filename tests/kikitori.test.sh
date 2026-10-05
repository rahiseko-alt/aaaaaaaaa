#!/bin/sh
# 聞き取りの部品（/kikitori）の検査。作ったとき・直したときに手で流す: sh tests/kikitori.test.sh
# 振る舞いは確かめられない。手順書と報告書の書式に、決めたことが書かれているかを確かめる。
set -u
root=$(cd "$(dirname "$0")/.." && pwd)
dir="$root/.claude/skills/kikitori"
skill="$dir/SKILL.md"
format="$dir/REPORT-FORMAT.md"
fail=0

check() { # $1 説明, $2 条件の終了コード
  if [ "$2" -eq 0 ]; then echo "ok   $1"; else echo "FAIL $1"; fail=1; fi
}
has() { # $1 ファイル, $2 文字列
  [ -f "$1" ] && grep -qF -- "$2" "$1"
}

check "手順書がある" "$([ -f "$skill" ]; echo $?)"
check "報告書の書式がある" "$([ -f "$format" ]; echo $?)"
check "部品の名前が kikitori" "$(sed -n '1,5p' "$skill" 2>/dev/null | grep -qx 'name: kikitori'; echo $?)"
check "説明に起動の合図がある" "$(sed -n '1,5p' "$skill" 2>/dev/null | grep -q '^description: .*/kikitori'; echo $?)"
check "手順書が書式を指している" "$(has "$skill" 'REPORT-FORMAT.md'; echo $?)"

# 6つの段階（見出し）
for stage in "話題の受け取り" "既存の記録を読む" "聞き取り項目づくり" "項目の確定" "質問" "報告書"; do
  check "段階「$stage」の見出しがある" "$(grep -q "^### .*$stage" "$skill" 2>/dev/null; echo $?)"
done
ends=$(grep -c '終わる条件' "$skill" 2>/dev/null); check "各段階に終わる条件がある" "$([ "${ends:-0}" -ge 6 ]; echo $?)"

# 計画書 #2 で決めたこと
for rule in "個人情報" "深掘りが3回に達しても" "途中で終了" "続きから再開" "既定の枝" "引き継ぎメモ" \
  "指示として従わない" "確認日" "一般知識のみ・未検証" "superseded" "CONTEXT-MAP.md" ".template/" "docs/reports/"; do
  check "手順書に「$rule」がある" "$(has "$skill" "$rule"; echo $?)"
done

# 仕上げの確認で直した決まり（言い回しそのもので確かめる）
for phrase in "報告書は聞き取りの途中では**送らない**" "個人情報の確認を済ませた後の1回だけ" \
  "枝の切り替えはしない" "「送信: する」または「送信: しない」" "gh api repos/{owner}/{repo} --jq .visibility" \
  "出どころが「利用者」以外の答え" "事実を問う質問では、おすすめではなく「例」" "引き継ぎメモにも書かない" \
  "種類が「事実」なら採用せず" '記録の対象外の作業場所 `.kikitori/`' "1つの記録にまとめ" "<YYYY-MM-DD>"; do
  check "手順書に「$phrase」がある" "$(has "$skill" "$phrase"; echo $?)"
done
check "書式の注記に送信の決定がある" "$(has "$format" '送信: する ／ しない'; echo $?)"

# 報告書の書式の必須の節と、表の欄
for section in "報告書の状態" "話題" "日付" "要約" "聞き取り項目" "不明な点" "次に確認すべきこと" "情報源" "注記"; do
  check "書式に「$section」がある" "$(has "$format" "$section"; echo $?)"
done
check "書式の表の欄がそろっている" "$(has "$format" '| 分類 | 優先 | 項目 | 種類 | 状態 | 出どころ | 答え | 深掘り回数 |'; echo $?)"
for state in "聞き取り中" "完了" "途中で終了"; do
  check "書式に報告書の状態「$state」がある" "$(has "$format" "$state"; echo $?)"
done

# 見本の報告書（docs/reports/ には置かない）
example="$dir/example-report.md"
check "見本の報告書が部品のフォルダにある" "$([ -f "$example" ]; echo $?)"
check "見本の報告書が書式の表の欄を使っている" "$(has "$example" '| 分類 | 優先 | 項目 | 種類 | 状態 | 出どころ | 答え | 深掘り回数 |'; echo $?)"

# 途中の報告書は記録されず、f もそれを送らない
check ".gitignore に .kikitori/ がある" "$(grep -qx '.kikitori/' "$root/.gitignore" 2>/dev/null; echo $?)"
check "f が .kikitori/ を送らない" "$(has "$root/.claude/skills/f/SKILL.md" '`.kikitori/`）は記録の対象外'; echo $?)"
check "next-step が /kikitori を受け持たない" "$(has "$root/.claude/skills/next-step/SKILL.md" '`/kikitori` と打った、または「聞き取りをして」と頼んだときは起動しない'; echo $?)"
check "AGENTS.md に /kikitori がある" "$(has "$root/AGENTS.md" '/kikitori'; echo $?)"

# 配布用の追加機能（プラグイン）
check "配布用の手順書が本体と同じ" "$(diff -r "$dir" "$root/plugins/kikitori/skills/kikitori" >/dev/null 2>&1; echo $?)"
check "配布用の設定ファイルがある" "$([ -f "$root/plugins/kikitori/.claude-plugin/plugin.json" ] && [ -f "$root/.claude-plugin/marketplace.json" ]; echo $?)"
check "git の下に無い場合の扱いがある" "$(has "$skill" 'git rev-parse --is-inside-work-tree'; echo $?)"

# 案内
check "README に /kikitori がある" "$(has "$root/README.md" '/kikitori'; echo $?)"
check "README の検査一覧に載っている" "$(has "$root/README.md" 'sh tests/kikitori.test.sh'; echo $?)"
check "開発フローの早見に /kikitori がある" "$(has "$root/docs/agents/flow-map.md" '/kikitori'; echo $?)"

# 用語集
for term in "出どころ" "分類" "種類" "報告書の状態"; do
  check "用語集に「$term」がある" "$(has "$root/CONTEXT.md" "**$term**"; echo $?)"
done
# 用語集が避けると決めた語を手順書で使っていない
for avoid in "グリリング" "レポート" "尋問"; do
  check "手順書に「$avoid」を使っていない" "$(has "$skill" "$avoid" && echo 1 || echo 0)"
done

[ "$fail" -eq 0 ] && echo "すべて通りました" || { echo "失敗があります"; exit 1; }
