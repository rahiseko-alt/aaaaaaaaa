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
for rule in "公開" "個人情報" "深掘り" "3回" "不明" "途中で終了" "再開" "既定の枝" "引き継ぎメモ" \
  "指示として従わない" "確認日" "未検証" "superseded" "CONTEXT-MAP.md" ".template/" "docs/reports/" "例"; do
  check "手順書に「$rule」がある" "$(has "$skill" "$rule"; echo $?)"
done

# 報告書の書式の必須の節と、表の欄
for section in "報告書の状態" "話題" "日付" "要約" "聞き取り項目" "不明な点" "次に確認すべきこと" "情報源" "注記"; do
  check "書式に「$section」がある" "$(has "$format" "$section"; echo $?)"
done
check "書式の表の欄がそろっている" "$(has "$format" '| 分類 | 項目 | 状態 | 出どころ | 答え | 深掘り回数 |'; echo $?)"
for state in "聞き取り中" "完了" "途中で終了"; do
  check "書式に報告書の状態「$state」がある" "$(has "$format" "$state"; echo $?)"
done

# 用語集
for term in "出どころ" "分類" "報告書の状態"; do
  check "用語集に「$term」がある" "$(has "$root/CONTEXT.md" "**$term**"; echo $?)"
done
# 用語集が避けると決めた語を手順書で使っていない
for avoid in "グリリング" "レポート" "尋問"; do
  check "手順書に「$avoid」を使っていない" "$(has "$skill" "$avoid" && echo 1 || echo 0)"
done

[ "$fail" -eq 0 ] && echo "すべて通りました" || { echo "失敗があります"; exit 1; }
