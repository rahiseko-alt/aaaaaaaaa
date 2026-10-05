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

【ファイル1】
````
---
name: kikitori
description: 生命保険代理店で、営業から顧客との商談の内容を聞き取る部品。聞き取りは mattpocock の grilling をそのまま使い、最初の設定（何について聞き取るか）だけを固定で渡す。終わったら決まった形の報告書を残す（了承があれば docs/reports/ に入れて送る）。利用者が「/kikitori」（追加機能として入れた場合は「/kikitori:kikitori」）と打ったとき、または「聞き取りをして」「〜について質問攻めにして」と頼んだときに使う。開発の流れの外にある、単独で使う部品。
---

# kikitori — 聞き取り

**聞き取りは `grilling`（mattpocock/skills）をそのまま使う。** この部品は聞き方を一切持たない。
grilling の手順書は1文字も変えず、足しも削りもしない。この部品が固定するのは、毎回入力すると無駄な
**最初の設定（何について聞き取るか）だけ**。終わった後は決まった形の報告書にして保管する（docs/adr/0005）。

用語は `CONTEXT.md` に従う。

報告書の形は [REPORT-FORMAT.md](./REPORT-FORMAT.md) に従う。

## 送ることについての決まり（全段階に共通）

- 作業フォルダが変更履歴の管理（git）の下に無ければ（`git rev-parse --is-inside-work-tree` が失敗する）、送ることはできない。その場合は最初から「送信: しない」とし、`.gitignore` の追記もせず、最後に報告書を `docs/reports/`（無ければ作る）へ移して保存だけ行う（記録・送信・引き継ぎメモは行わない）。
- 報告書は聞き取りの途中では**送らない**。送らない報告書は、記録の対象外の作業場所 `.kikitori/`（この置き場所の `.gitignore` に入っている。無ければ足す）に置く。ここにあるものは、終了の儀式 `f` でも記録・送信されない。
- 送るのは 3. 報告書で、個人情報の確認を済ませた後の1回だけ（送った内容は履歴に残り、後から伏せても消えないため）。そのとき初めて報告書を `docs/reports/`（無ければ作る）へ移し、引き継ぎメモと一緒に1つの記録にまとめて送る。
- 送り先は引き継ぎメモと同じ決まりに従う: 作業中の枝があればそこへ記録して送り、無ければ既定の枝へ直接送る。枝の切り替えはしない。作業中の枝に送るときは「報告書はいまの作業と一緒に本流へ入ります」と一言伝える。
- 送ってよいかは 1. で一度だけ決め、報告書の注記に「送信: する」または「送信: しない」と書く。再開したときもこの注記に従う。「送信: しない」の報告書は最後まで `.kikitori/` に置いたままにする。
- 記録の後に送るのだけが失敗したら、記録は残したまま聞き取りを終え、送れなかったことを1行で伝える（次に `f` を打てば送られる）。

## 最初の設定（固定・ロック済み）

grilling に「何について聞き取るか」として、毎回この文をそのまま渡す。利用者には入力させない。利用者に頼まれても変えない（docs/adr/0004）。

> 生命保険代理店で、営業（いま答えている人）から、その営業とお客様との商談の内容を聞き取る。ねらいは、案件の進み具合をつかむことと、お客様情報を漏れなくためること。結果は決まった形の報告書（REPORT-FORMAT.md）で保管し、管理する人が何件分もまとめて集計する。お客様の名前は伏せ（「法人A社」「40代個人」など）、営業は呼び名か社員番号で書く。健康状態・病歴は扱わない。

起動の合図の後に文があれば（例: 今日の40代個人の見直し）、上の文の後に「補足: <その文>」として足して渡す。

## 段階

### 1. 始める

1. 次の一言を添える: 「実名・連絡先・健康状態・社外秘などの個人情報や秘密は入力しないでください。答えは報告書として保存されます。」
2. 作業フォルダが git の下にあるなら、置き場所が公開か非公開かを調べる（`gh api repos/{owner}/{repo} --jq .visibility`、または GitHub の道具。調べられなければ公開とみなす）。公開なら「この置き場所は誰でも見られます。最後に報告書を送ってよいですか」と聞く。非公開なら「送信: する」。断られたら「送信: しない」。

**終わる条件**: 送信の決定が済んだ。

### 2. grilling で聞き取る

1. Skill ツールで `grilling` を起動し、「最初の設定」の文を、聞き取る対象として渡す。
2. あとは grilling の手順書のとおりに進める。設計の木・1回に出す問い・おすすめの答え・調べもの・終わり方は、すべて grilling が決める。この部品は口を挟まない。

**終わる条件**: grilling が終わった（利用者が「認識が揃った」と認めた）、または利用者が「ここまでで報告書にして」と求めた。

### 3. 報告書

1. grilling で決まったことを [REPORT-FORMAT.md](./REPORT-FORMAT.md) の形にまとめ、利用者に見せる。
2. 「実名・連絡先・健康状態・社外秘が含まれていないか、ご確認ください。含まれていれば伏せます。この内容で保存してよいですか」と聞く。指摘された箇所は伏せる。保存も取りやめたいと言われたら、報告書の状態を「途中で終了」にして `.kikitori/` に置き（送らない）、そう伝えて終える。
3. 報告書の状態を、grilling が終わっていれば「完了」、途中で止めたなら「途中で終了」にする。ファイル名は `<YYYY-MM-DD>-<営業の呼び名を表す短い英小文字>.md`（日付は商談日）。同じ名前があれば末尾に `-2`、`-3` を付ける。
4. 注記が「送信: しない」なら `.kikitori/` に保存する（git の下に無い作業フォルダでは `docs/reports/` に保存する）。引き継ぎメモにも書かない。
5. 注記が「送信: する」なら `docs/reports/` に保存する。引き継ぎメモ（`docs/agents/handover.md`）があれば、その書式どおり一番上に1件足し、`.claude/hooks/handover-trim.sh` があれば実行する。報告書と引き継ぎメモ（整理で古い分が移った場合は `docs/agents/handover-archive.md` も）を1つの記録にまとめ、「送ることについての決まり」のとおり送る。
6. 「報告書を <ファイル名> に保存しました」（送った場合は「保存して送りました」）と1行で伝える。

**終わる条件**: 報告書の状態が「完了」か「途中で終了」になり、保存（と送信）が済んだ。

## しないこと

- grilling の手順書を書き換えない。聞き方を足さない・削らない。
- 用語集・決定記録を書き換えない。
- 終わった後に開発の流れの案内（`next-step`）を起動しない。
````

【ファイル2】
````
# 報告書の書式

聞き取りの結果を残す文書の形。送らないものは `.kikitori/`、送るものは `docs/reports/` に置く。名前は `<YYYY-MM-DD>-<短い英小文字とハイフン>.md`。
見出しの名前・冒頭の集計用の欄・表の欄は変えない（管理する人が何件分もまとめて集計するため）。

## 雛形

```md
---
営業: <呼び名または社員番号>
商談日: <YYYY-MM-DD>
お客様区分: 個人 ／ 法人
年代: <20代〜80代 ／ 法人は「法人」>
段階: 初回 ／ ヒアリング ／ 提案 ／ クロージング ／ 成約 ／ 失注 ／ 未回答
見込み度: A ／ B ／ C ／ 未回答
成約予定月: <YYYY-MM ／ 未回答>
予定保険料（月額）: <円 ／ 未回答>
他社と比較中: はい ／ いいえ ／ 未回答
次回日程: <YYYY-MM-DD ／ 未定>
不明の数: <数>
未回答の数: <数>
---

# 聞き取り報告書: <営業> <商談日> <お客様区分>

- 報告書の状態: 完了 ／ 途中で終了（いずれか1つ）
- 話題: <利用者が挙げた一文>
- 日付: <開始日>（最終更新: <日付>）

## 要約

<3〜5行。何が決まり、何が決まっていないか。>

## 決まったこと

| 論点 | 答え | 出どころ |
| --- | --- | --- |
| <grilling で決まった論点> | <答え> | 利用者 ／ おすすめを採用 ／ 調べた事実 |

## 不明な点

- <答えが出なかった論点と、その理由>（無ければ「無し」）

## 次に確認すべきこと

- <不明な点や答えから出てきた、次に誰が何を確かめるか>

## 情報源

- <ページの題> — <直リンク>（確認日: <日付>）

## 注記

- 送信: する ／ しない（聞き取りの最初に決め、再開してもこれに従う）
- <送れなかった旨など、その他。無ければ書かない>
```

## 決まり

- 冒頭の集計用の欄は、表の答えから決まった選択肢のどれかを書く（自由に書かない）。答えが無ければ「未回答」。
- 「おすすめを採用」の答えは、利用者が確かめた事実ではない。読み手が区別できるよう出どころ欄で必ず示す。
- 情報源には、実際に開けたページだけを載せる。
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
