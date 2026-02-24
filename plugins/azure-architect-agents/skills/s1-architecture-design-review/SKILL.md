---
name: s1-architecture-design-review
description: |
  Azure architecture multi-perspective design review using WAF 5 pillars and reference architecture comparison.
  Trigger on: "この設計をレビューして", "WAF観点でチェック", "アーキテクチャレビュー",
  or when architecture diagrams, IaC code, or design documents are presented for review.
---

# S1. Architecture Design Review（アーキテクチャ設計レビュー）

## Architecture Context

このスキルは Azure Architect Agents の二層システムの一部です:
- **Skills (Workflow Orchestrators)**: ユーザー向けワークフロー（本スキル）
- **Sub-Agents (Specialized Executors)**: Task tool 経由で呼び出す専門エージェント

```
User → Skill Layer (S1-S5) → Sub-Agent Layer (A1-A12)
```

### プラグインファイルパス

本スキルの SKILL.md が配置されているディレクトリから相対パスで以下のリソースにアクセスしてください:
- **Sub-Agent プロンプト**: `../../agents/a{NN}-*.md`
- **知識ファイル**: `../../knowledge/*.md`
- **使用例**: `../../examples/*.md`

### Sub-Agent 呼び出しパターン

```
Task tool:
  subagent_type: "general-purpose"
  prompt: [agents/a{NN}-*.md の内容] + [関連 knowledge ファイル] + [ユーザー入力/コンテキスト]
```

---

## 目的
既存または提案中の Azure アーキテクチャを **WAF 5 柱 + リファレンスアーキテクチャ比較** の多角的観点でレビューし、優先度付きの改善アクションリストを生成する。

## トリガー条件
以下のようなユーザー入力で起動:
- 「この設計をレビューして」
- 「WAF 観点でチェックして」
- 「アーキテクチャレビューをお願い」
- 設計書、IaC コード、アーキテクチャ図の説明が提示された場合

## 入力要件
ユーザーから以下を収集する（AskUserQuestion を使用）:

### 必須情報
1. **アーキテクチャの説明**: 設計書、IaC コード、構成図のテキスト説明のいずれか
2. **ワークロード種別**: Web アプリ / API / データ分析 / AI/ML / IoT / その他
3. **主要な非機能要件**: SLA目標、想定トラフィック、データ量

### 任意情報
4. **レビュー重点柱**: 全柱 or 特定柱に絞る
5. **既知の制約**: 予算、リージョン、コンプライアンス要件
6. **コンテキスト**: 新規設計 / 既存改善 / 移行先設計

## オーケストレーション手順

### Step 1: 入力解析と準備
- ユーザー入力を構造化
- IaC コードの場合はリソース一覧を抽出
- レビュー対象のスコープを明確化

### Step 2: リファレンスアーキテクチャマッチング
```
Task: A3. Reference Architecture Matcher
Input: ワークロード種別 + 非機能要件 + アーキテクチャ説明
Output: 最適リファレンス、ギャップ分析
```

### Step 3: WAF 5 柱レビュー（並列実行）
5つの Task を **同時に** 起動する:

```
Task x5: A1. WAF Pillar Analyst
  - Pillar: Reliability（信頼性）
  - Pillar: Security（セキュリティ）
  - Pillar: Cost Optimization（コスト最適化）
  - Pillar: Operational Excellence（オペレーショナルエクセレンス）
  - Pillar: Performance Efficiency（パフォーマンス効率）
Input（共通）: アーキテクチャ説明 + リファレンス比較結果
Output（各柱）: チェックリスト Pass/Fail/Warning + 改善提案
```

### Step 4: 条件付き深掘り分析
WAF レビュー結果に基づき、Critical/High の問題がある柱について追加分析を実行:

| 条件 | 追加エージェント | 目的 |
|------|----------------|------|
| Reliability に Critical/High 問題 | A9. DR/HA Planner | DR/HA 設計の詳細改善提案 |
| Security に Critical/High 問題 | A6. Security Auditor | セキュリティ深掘り分析と修正コード |
| Cost に Critical/High 問題 | A7. Cost Estimator | コスト最適化の具体的提案 |
| Performance に Critical/High 問題 | A5. Network Architect | ネットワーク/性能改善設計 |
| 可用性 99.99%+ 要件 | A11. Mission-Critical Analyst | ミッションクリティカル設計分析 |

### Step 5: 結果統合とレポート生成

## 出力フォーマット

```markdown
# アーキテクチャ設計レビュー結果

## エグゼクティブサマリー
- **総合評価**: [★★★☆☆] (3/5)
- **レビュー日**: YYYY-MM-DD
- **対象**: [ワークロード名/説明]
- **リファレンス**: [最も近いリファレンスアーキテクチャ名 + URL]

## WAF 5 柱スコアカード

| 柱 | スコア | Critical | High | Medium | Low |
|----|--------|----------|------|--------|-----|
| Reliability | ★★★☆☆ | 0 | 2 | 3 | 1 |
| Security | ★★★★☆ | 0 | 0 | 2 | 3 |
| Cost Optimization | ★★☆☆☆ | 1 | 1 | 2 | 0 |
| Operational Excellence | ★★★☆☆ | 0 | 1 | 2 | 2 |
| Performance Efficiency | ★★★★☆ | 0 | 0 | 1 | 2 |

## リファレンスアーキテクチャとのギャップ分析
[A3 の出力を要約]

## Top 10 改善アクション（優先順位付き）

### 1. [Critical] [柱名] 改善タイトル
- **問題**: 現状の問題点
- **リスク**: 放置した場合の影響
- **推奨アクション**: 具体的な改善手順
- **関連チェックリスト**: [WAF ID]
- **関連デザインパターン**: [パターン名]

(以下同様)

## 柱別詳細レビュー

### Reliability（信頼性）
[A1 Reliability の詳細出力]

### Security（セキュリティ）
[A1 Security の詳細出力]

### Cost Optimization（コスト最適化）
[A1 Cost の詳細出力]

### Operational Excellence（オペレーショナルエクセレンス）
[A1 OpEx の詳細出力]

### Performance Efficiency（パフォーマンス効率）
[A1 Performance の詳細出力]

## 推奨デザインパターン
[該当するクラウドデザインパターンの一覧と適用箇所]

## 次のステップ
[改善の実装ロードマップ提案]
```

## エラーハンドリング
- ユーザー入力が不十分な場合: 追加質問で情報を補完
- サブエージェントがタイムアウトした場合: 取得済み結果で部分レポートを生成し、未完了部分を明示
- IaC コードの解析エラー: テキスト説明ベースのレビューにフォールバック

## 知識ファイル参照
- `../../knowledge/waf-checklists.md` — WAF チェックリスト全体
- `../../knowledge/reference-architectures-catalog.md` — リファレンスアーキテクチャ一覧
- `../../knowledge/cloud-design-patterns.md` — クラウドデザインパターン

## Skill-Agent Invocation Matrix (S1)
| Agent | Required/Conditional |
|-------|---------------------|
| A1. WAF Pillar Analyst | Required |
| A3. Reference Architecture Matcher | Required |
| A5. Network Architect | Conditional |
| A6. Security & Compliance Auditor | Conditional |
| A7. Cost Estimator & Optimizer | Conditional |
| A9. DR/HA Planner | Conditional |
| A11. Mission-Critical Analyst | Conditional |
