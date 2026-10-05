#!/bin/sh
# 聞き取りの部品（/kikitori）の検査。作ったとき・直したときに手で流す: sh tests/kikitori.test.sh
# 振る舞いは確かめられない。決めたこと（grilling をそのまま使う・最初の設定だけ固定）が守られているかを確かめる。
set -u
root=$(cd "$(dirname "$0")/.." && pwd)
dir="$root/.claude/skills/kikitori"
skill="$dir/SKILL.md"
format="$dir/REPORT-FORMAT.md"
grilling="$root/.claude/skills/grilling/SKILL.md"
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

# grilling をそのまま使う（docs/adr/0005）
check "手順書が grilling を Skill ツールで起動する" "$(has "$skill" 'Skill ツールで `grilling` を起動'; echo $?)"
check "手順書が grilling を書き換えないと明記" "$(has "$skill" 'grilling の手順書を書き換えない'; echo $?)"
for own in "1回の質問は多くても5問" "深掘り" "残りの未回答" "AGENCY-ITEMS.md" "18項目"; do
  check "手順書に独自の聞き方「$own」が無い" "$(has "$skill" "$own" && echo 1 || echo 0)"
done
check "独自の18項目のファイルが無い" "$([ ! -e "$dir/AGENCY-ITEMS.md" ]; echo $?)"

# 最初の設定だけ固定（docs/adr/0004）
check "最初の設定の節がある" "$(has "$skill" '## 最初の設定（固定）'; echo $?)"
for phrase in "生命保険代理店で、営業（いま答えている人）から" "案件の進み具合" "お客様情報" "利用者には入力させない" "営業を誘導しない" "問いは1問ずつ出し" "選択肢（(a)(b)" "grilling の書式の見本（❓・➡️・番号）は使わない" "最初の問いは営業の呼び名" "引き継げる記録" "何回目の面談か" "お客様が実際に言った言葉" "1つの問いでは1つのことだけを聞く" "本人から直接聞いたのか" "契約者・被保険者・受取人" "役員退職金規程"; do
  check "最初の設定に「$phrase」がある" "$(has "$skill" "$phrase"; echo $?)"
done

# 送ることの決まり
for phrase in "報告書は**送らない**" "記録（git commit）も送信（push）もしない" "では、今から聞き取りを始めます。" \
  "git rev-parse --is-inside-work-tree" "全文を会話にも表示する" "報告書の中身を、引き継ぎメモなど報告書の外の記録に書き写さない" "Skill ツールで見つからなければ"; do
  check "手順書に「$phrase」がある" "$(has "$skill" "$phrase"; echo $?)"
done
for own in "送信: する" "gh api" "送ってよいですか"; do
  check "手順書に送る道が残っていない「$own」" "$(has "$skill" "$own" && echo 1 || echo 0)"
done
for phrase in "意向把握の書面:" "重要事項の説明:" "払込方法:" "年払いは12で割って" "予定保険料の確度:" "半角数字だけ" "見込み度の目安" "段階の目安" "推測は書かない" "Claude が営業の答えに当てはめて決めない" "未回答の数＝" "不明の数＝" "## 約束と宿題" "## いま入っている保険" "推測で足さない"; do
  check "書式に「$phrase」がある" "$(has "$format" "$phrase"; echo $?)"
done
for own in "docs/adr/" "CONTEXT.md" "利用者に頼まれても変えない"; do
  check "手順書が配布先に無いものや利用者を締め出す文を含まない「$own」" "$(has "$skill" "$own" && echo 1 || echo 0)"
done
for phrase in "記録（git commit）も送信（push）もしないでください" "上書きせず、すでにあるものを使ってください" "上書きしてよいか私に聞いてください" "の1行を足してください"; do
  check "貼る文章に「$phrase」がある" "$(has "$root/kit/install-prompt.md" "$phrase"; echo $?)"
done
check "貼る文章が push させない" "$(sed -n '1,/【ファイル1】/p' "$root/kit/install-prompt.md" | grep -q 'してください。.*push' && echo 1 || echo 0)"

# 報告書の書式（集計用の欄）
for key in "営業:" "商談日:" "お客様区分:" "関係:" "面談回数:" "段階:" "見込み度:" "成約予定月:" "次回日程:"; do
  check "書式に集計用の欄「$key」がある" "$(has "$format" "$key"; echo $?)"
  check "見本に集計用の欄「$key」がある" "$(has "$dir/example-report.md" "$key"; echo $?)"
done
check "書式に引き継ぎの節がある" "$(has "$format" "## 引き継ぎの勘所" && has "$format" "## 今回の会話"; echo $?)"
check "書式の表の欄がそろっている" "$(has "$format" '| 論点 | 答え | 出どころ |'; echo $?)"
check "見本の表の欄がそろっている" "$(has "$dir/example-report.md" '| 論点 | 答え | 出どころ |'; echo $?)"

# 配布物に grilling が書き換えずに入っている
check "配布用フォルダの grilling が元と同じ" "$(diff "$grilling" "$root/kit/kikitori-kit/.claude/skills/grilling/SKILL.md" >/dev/null 2>&1; echo $?)"
check "配布用フォルダに grilling のライセンスがある" "$(has "$root/kit/kikitori-kit/.claude/skills/kikitori/GRILLING-LICENSE" 'MIT License'; echo $?)"
check "追加機能の grilling が元と同じ" "$(diff "$grilling" "$root/plugins/kikitori/skills/grilling/SKILL.md" >/dev/null 2>&1; echo $?)"
check "zip の grilling が元と同じ" "$(unzip -p "$root/dist/kikitori-kit.zip" kikitori-kit/.claude/skills/grilling/SKILL.md 2>/dev/null | diff - "$grilling" >/dev/null 2>&1; echo $?)"
prompt="$root/kit/install-prompt.md"
block() { # $1 見出し: 貼る文章から、その見出しのファイルの中身を取り出す
  awk -v h="【$1】" '$0==h{f=1;next} f&&/^````$/{if(s){exit}else{s=1;next}} f&&s{print}' "$prompt"
}
check "貼る文章のファイル1が kikitori の手順書と同じ" "$(block ファイル1 | diff - "$skill" >/dev/null 2>&1; echo $?)"
check "貼る文章のファイル2が報告書の書式と同じ" "$(block ファイル2 | diff - "$format" >/dev/null 2>&1; echo $?)"
check "貼る文章のファイル3が grilling と同じ" "$(block ファイル3 | diff - "$grilling" >/dev/null 2>&1; echo $?)"
check "貼る文章のファイル4がライセンスと同じ" "$(block ファイル4 | diff - "$root/licenses/mattpocock-skills-LICENSE" >/dev/null 2>&1; echo $?)"
check "貼る文章が外から取り寄せない" "$(has "$prompt" 'raw.githubusercontent.com' && echo 1 || echo 0)"

# 配布物の kikitori が本体と同じ
check "配布用フォルダの手順書が本体と同じ" "$(diff "$skill" "$root/kit/kikitori-kit/.claude/skills/kikitori/SKILL.md" >/dev/null 2>&1 && diff "$format" "$root/kit/kikitori-kit/.claude/skills/kikitori/REPORT-FORMAT.md" >/dev/null 2>&1; echo $?)"
check "追加機能の手順書が本体と同じ" "$(diff -r -x GRILLING-LICENSE "$dir" "$root/plugins/kikitori/skills/kikitori" >/dev/null 2>&1; echo $?)"
check "zip の手順書が本体と同じ" "$(unzip -p "$root/dist/kikitori-kit.zip" kikitori-kit/.claude/skills/kikitori/SKILL.md 2>/dev/null | diff - "$skill" >/dev/null 2>&1; echo $?)"
check "配布用の設定ファイルがある" "$([ -f "$root/plugins/kikitori/.claude-plugin/plugin.json" ] && [ -f "$root/.claude-plugin/marketplace.json" ]; echo $?)"

# ほかの部品との取り合い
check ".gitignore に docs/reports/ がある" "$(grep -qx 'docs/reports/' "$root/.gitignore" 2>/dev/null; echo $?)"
check "f が報告書を送らない" "$(has "$root/.claude/skills/f/SKILL.md" '`docs/reports/`）は記録の対象外'; echo $?)"
check "next-step が /kikitori を受け持たない" "$(has "$root/.claude/skills/next-step/SKILL.md" '`/kikitori` と打った、または「聞き取りをして」と頼んだときは起動しない'; echo $?)"
check "AGENTS.md に /kikitori がある" "$(has "$root/AGENTS.md" '/kikitori'; echo $?)"
check "README の検査一覧に載っている" "$(has "$root/README.md" 'sh tests/kikitori.test.sh'; echo $?)"
check "grilling の置き場所に手元の追加が無い" "$([ ! -e "$root/kit/kikitori-kit/.claude/skills/grilling/LICENSE" ] && [ ! -e "$root/plugins/kikitori/skills/grilling/LICENSE" ]; echo $?)"
check "決定記録 0004 と 0005 がある" "$([ -f "$root/docs/adr/0004-lock-life-agency-sales-interview.md" ] && [ -f "$root/docs/adr/0005-use-grilling-verbatim.md" ]; echo $?)"

[ "$fail" -eq 0 ] && echo "すべて通りました" || { echo "失敗があります"; exit 1; }
