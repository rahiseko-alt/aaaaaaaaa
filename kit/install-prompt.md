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

【ファイル1】
````
---
name: kikitori
description: 生命保険代理店で、営業から顧客との商談の内容を聞き取る部品。聞き取りは mattpocock の grilling をそのまま使い、最初の設定（何について聞き取るか）だけを固定で渡す。終わったら決まった形の報告書を docs/reports/ に保存する（どこにも送らない）。利用者が「/kikitori」（追加機能として入れた場合は「/kikitori:kikitori」）と打ったとき、または「商談の聞き取りをして」と頼んだときに使う。開発の流れの外にある、単独で使う部品。
---

# kikitori — 聞き取り

**聞き取りは `grilling`（mattpocock/skills）をそのまま使う。** この部品は聞き方を一切持たない。
grilling の手順書は1文字も変えず、足しも削りもしない。この部品が固定するのは、毎回入力すると無駄な
**最初の設定（何について聞き取るか）だけ**。終わった後は決まった形の報告書にして保管する。

報告書の形は [REPORT-FORMAT.md](./REPORT-FORMAT.md) に従う。

## 報告書の置き場所（全段階に共通）

- 報告書は**送らない**。記録（git commit）も送信（push）もしない。作業フォルダの `docs/reports/`（無ければ作る）に保存するだけにする。
- 作業フォルダが git の下にあるとき（`git rev-parse --is-inside-work-tree` が成功する）は、`docs/reports/` が `.gitignore` に入っているか確かめ、無ければ1行足す（`.gitignore` が改行で終わっていなければ先に改行を足す）。報告書が誤って記録・送信されないようにするため。
- 報告書は、保存したうえで全文を会話にも表示する（作業環境が消えても、会話に残るようにするため）。保存の確認で見せた全文から変わっていなければ、もう一度は表示せず「確認でお見せした全文が最終版です」と伝える。
- 報告書の中身を、引き継ぎメモなど報告書の外の記録に書き写さない。

## 最初の設定（固定）

grilling に「何について聞き取るか」として、毎回この文をそのまま渡す。利用者には入力させない。

> 生命保険代理店で、営業（いま答えている人）から、その営業とお客様との商談の内容を聞き取る。報告書は、別の担当者がそれだけを読んで、このお客様との関係と商談をそのまま引き継げる記録として使う。ねらいは、案件の進み具合をつかむことと、お客様情報を漏れなくためること。結果は決まった形の報告書（REPORT-FORMAT.md）で保管し、管理する人が何件分もまとめて集計する。お客様の名前は伏せ（「法人A社」「40代個人」など）、営業は呼び名か社員番号で書く。健康状態・病歴は扱わない。
>
> 営業を誘導しない。問いにおすすめの答えや答えの例を付けない（おすすめの欄には「なし」とだけ書く）。前提を置いた問い・はい／いいえで答えさせる問い・問いの中に答えの例を含む問いを避け、開いた問いで聞く。1つの問いでは1つのことだけを聞く。答えが感想や要約（「感触は良かった」「いつもどおり」など）なら、お客様が実際に言った言葉・したこと・数字・日付まで掘り下げる。人から聞いた話（「主人が嫌がる」など）は、誰がいつ言ったのか、本人から直接聞いたのかまで確かめる。
>
> 保険代理店の引き継ぎで残すべきとされる、次の観点を漏れなく扱う。
> - 関係の履歴: 新規か既契約者か紹介か、このお客様と何回目の面談か、これまでの面談の日付と間隔、これまでの経緯（前回までの提案・断られた理由・約束）、前回から変わったこと
> - 今回の会話: 何をどの順で話したか、お客様が実際に言った言葉（希望・不安・断りの言葉）、営業が説明したこと
> - お客様の背景: 家族構成と年齢・扶養、今後5〜10年の予定（進学・住宅・退職など）、いま入っている保険（会社・種類・入った時期・保障・保険料・更新や満期・契約者・被保険者・受取人）とそれを選んだ理由
> - 関係の勘所: 窓口・決める人（例: 奥様）、連絡がつきやすい方法と時間、避けるべき話題や注意点、紹介者との関係
> - 意向と説明の記録: 最初の意向と今の意向の違い、重要事項の説明、複数社を比べて勧めた理由、意向を確かめた書類、高齢のお客様への配慮（家族の同席・複数回の面談）
> - 法人のお客様なら: 決算月、役員退職金規程の有無、経理や意思決定に関わる人、後継者、営業が税務をどう説明したか（損金の扱い・解約返戻金が多くなる時期）
> - 進み具合と次: 段階、決め手と懸念、提案する保険の契約者・被保険者・受取人、切り替えや実行の時期、約束・宿題（誰が・何を・いつまでに）、次回の日程と目的

起動の合図の後に文があれば（例: 今日の40代個人の見直し）、上の文の後に「補足: <その文>」として足して渡す。

## 段階

### 1. 始める

1. 最初に「では、今から聞き取りを始めます。」と宣言する。
2. 続けて次の一言を添える: 「実名・連絡先・健康状態・社外秘などの個人情報や秘密は入力しないでください。答えは報告書としてこの作業フォルダに保存し、どこにも送りません。」
3. クラウドの作業環境（claude.ai/code など）なら「この作業環境を閉じると、フォルダの中の報告書は消えます。最後に会話に表示する全文を写してください。終了の確認などで『失われるものはありません』と表示されても、この報告書は含まれていません」と添える。

**終わる条件**: 宣言と注意を伝えた。

### 2. grilling で聞き取る

1. Skill ツールで `grilling` を起動し、「最初の設定」の文を、聞き取る対象として渡す。Skill ツールで見つからなければ、`.claude/skills/grilling/SKILL.md`（または `~/.claude/skills/grilling/SKILL.md`）を読み、その手順どおりに進める。
2. あとは grilling の手順書のとおりに進める。設計の木・1回に出す問い・おすすめの答え・調べもの・終わり方は、すべて grilling が決める。この部品は口を挟まない。

**終わる条件**: grilling が終わった（利用者が「認識が揃った」と認めた）、または利用者が「ここまでで報告書にして」と求めた。

### 3. 報告書

1. grilling で決まったことを [REPORT-FORMAT.md](./REPORT-FORMAT.md) の形にまとめ、利用者に見せる。
2. 「実名・連絡先・健康状態・社外秘が含まれていないか、ご確認ください。含まれていれば伏せます。この内容で保存してよいですか」と聞く。指摘された箇所は伏せる。保存も取りやめたいと言われたら、保存せずにそう伝えて終える。
3. 報告書の状態を、grilling が終わっていれば「完了」、途中で止めたなら「途中で終了」にする。ファイル名は `<YYYY-MM-DD>-<営業の呼び名を表す英小文字・数字・ハイフン>.md`（日付は商談日。集計欄の商談日が「未回答」なら今日の日付。呼び名が分からなければ `unknown`。日本語の呼び名はローマ字にする。例: tanaka、s1234）。同じ名前があれば末尾に `-2`、`-3` を付ける。
4. 「報告書の置き場所」のとおりに保存する。
5. 「報告書を <ファイル名> に保存しました（どこにも送っていません）」と1行で伝えて終える。この部品は、終わった後に次の作業の案内を出さない（組み込みのときに頼まれた「次回からの始め方」の一言は除く）。

**終わる条件**: 報告書の状態が「完了」か「途中で終了」になり、保存が済んだ。

## しないこと

- grilling の手順書を書き換えない。聞き方を足さない・削らない。
````

【ファイル2】
````
# 報告書の書式

聞き取りの結果を残す文書の形。置き場所は手順書（SKILL.md）の「報告書の置き場所」に従う。名前は `<YYYY-MM-DD>-<英小文字・数字・ハイフン>.md`。
見出しの名前・冒頭の集計用の欄・表の欄は変えない（管理する人が何件分もまとめて集計するため）。

## 雛形

```md
---
営業: <呼び名または社員番号>
商談日: <YYYY-MM-DD ／ 未回答>
お客様区分: 個人 ／ 法人 ／ 未回答
関係: 新規 ／ 既契約者 ／ 紹介 ／ 未回答
面談回数: <このお客様と何回目か。半角数字 ／ 未回答>
年代: <10代〜90代 ／ 法人 ／ 未回答>
段階: 初回 ／ ヒアリング ／ 提案 ／ クロージング ／ 成約 ／ 失注 ／ 未回答
見込み度: A ／ B ／ C ／ 未回答
成約予定月: <YYYY-MM ／ 未回答>
予定保険料（月額）: <半角数字のみ。例 12000 ／ 未回答>
払込方法: 月払い ／ 年払い ／ 一時払い ／ 未回答
予定保険料の確度: 確定 ／ 概算 ／ 未回答
他社と比較中: はい ／ いいえ ／ 未回答
次回日程: <YYYY-MM-DD ／ 未定 ／ 未回答>
意向把握の書面: あり ／ なし ／ 未回答
重要事項の説明: 済 ／ 未 ／ 未回答
不明の数: <「不明な点」に挙げた件数>
未回答の数: <上の欄のうち「未回答」と書いた欄の数>
---

# 聞き取り報告書: <営業> <商談日> <お客様区分>

- 報告書の状態: 完了 ／ 途中で終了（いずれか1つ）
- 話題: <起動時に添えた補足の一文。無ければ「無し」>
- 日付: <聞き取りをした日>

## 要約

<3〜5行。何が決まり、何が決まっていないか。>

## 今回の会話

<何をどの順で話したか。お客様が実際に言った言葉は「」で残す。>

## 引き継ぎの勘所

- 窓口・決める人: <>
- 連絡がつきやすい方法と時間: <>
- 避けるべき話題・注意点: <>
- これまでの経緯（面談ごとの日付・提案・断られた理由・約束）: <>
- 紹介者との関係: <>

## いま入っている保険

| 会社 | 種類 | 入った時期 | 保障 | 保険料（月額） | 更新・満期 | 契約者・被保険者・受取人 | 選んだ理由 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| <> | <> | <> | <> | <> | <> | <> | <> |

## 約束と宿題

| 誰が | 何を | いつまでに |
| --- | --- | --- |
| <営業／お客様など> | <> | <YYYY-MM-DD ／ 未定> |

## 決まったこと

| 論点 | 答え | 出どころ |
| --- | --- | --- |
| <grilling で決まった論点> | <答え> | 利用者 ／ 調べた事実 |

## 不明な点

- <答えが出なかった論点と、その理由>（無ければ「無し」）

## 次に確認すべきこと

- <営業の答えから出てきた、次に確かめること。営業が言っていないことを推測で足さない>（無ければ「無し」）

## 情報源

- <ページの題> — <直リンク>（確認日: <日付>）（無ければ「無し」）

## 注記

- <その他。無ければ「無し」>
```

## 決まり

- 冒頭の集計用の欄は、表の答えから決まった選択肢のどれかを書く（自由に書かない）。答えが無ければ「未回答」。
- 集計欄と表には、営業が答えたことだけを書く。Claude の推測は書かない。
- 「わからない」と答えた欄は、集計欄に「未回答」と書き、「不明な点」にも挙げる。
- 段階の目安: 初回＝初めて会った／ヒアリング＝希望を聞いている、まだ設計書を出していない／提案＝設計書や見積もりを出した／クロージング＝申し込みの日取りを決めている／成約＝申し込みを受けた／失注＝お客様が断った。
- 見込み度の目安: A＝お客様が申し込む意思をはっきり言った／B＝前向きだが、決める人・時期・金額のどれかが残っている／C＝それ以外。
- 段階と見込み度は、営業が答えた値を書く。目安は言葉の意味をそろえるためのもので、Claude が営業の答えに当てはめて決めない。営業が答えなければ「未回答」。
- 未回答の数＝集計欄のうち「未回答」と書いた欄の数。「未定」は数えない。
- 不明の数＝「不明な点」に挙げた件数。「わからない」と答えた論点はすべて「不明な点」に挙げる（集計欄の外の論点も含む）。途中で終了して聞けなかった欄は「未回答」にだけ数え、「不明な点」には挙げない。
- 金額は、集計欄でも本文の表でも半角数字だけで書く（円・カンマ・「約」「およそ」を付けない）。概算なら「予定保険料の確度」を「概算」にする。予定保険料が「未回答」なら、確度も「未回答」にする（未回答の数には、確度は数えない）。年払いは12で割って月額に直す（端数は切り捨て）。一時払いは月額に直さず、予定保険料（月額）を「未回答」にして本文の表に一時払いの額を書く。
- 情報源には、実際に開けたページだけを載せる。
- 「引き継ぎの勘所」「いま入っている保険」「約束と宿題」の各欄は、聞けなかったら「未回答」と書く（空けない）。
````

【ファイル3】
````
---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Format a round like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it; don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report; ask the rest of the frontier now. The _decisions_ are the user's: put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.
````

【ファイル4】
````
MIT License

Copyright (c) 2026 Matt Pocock

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
````
