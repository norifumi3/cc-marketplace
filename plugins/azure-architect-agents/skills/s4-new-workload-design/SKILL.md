---
name: s4-new-workload-design
description: |
  Zero-to-architecture design for new Azure workloads with reference selection, detailed design, IaC code generation, and WAF review.
  Trigger on: "Webアプリのアーキテクチャを設計して", "AKSでマイクロサービスを構築したい",
  "新しいシステムのアーキテクチャを考えて", "Azureでデータ分析基盤を作りたい",
  or when users need to design a new workload from scratch on Azure.
---

# S4. New Workload Design（新規ワークロード設計）

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
新規ワークロードのアーキテクチャをゼロから設計する。要件ヒアリングからリファレンス選定、詳細設計、IaC コード生成、WAF レビューまでの一貫したワークフローを提供。

## トリガー条件
- 「Web アプリのアーキテクチャを設計して」
- 「AKS でマイクロサービスを構築したい」
- 「新しいシステムのアーキテクチャを考えて」
- 「Azure でデータ分析基盤を作りたい」

## 入力要件

### 必須情報（AskUserQuestion で収集）
1. **ワークロード種別**:
   - Web アプリケーション（SPA / SSR / API）
   - コンテナ / マイクロサービス
   - データ分析 / データプラットフォーム
   - AI/ML ワークロード
   - IoT ソリューション
   - バッチ処理 / HPC
   - その他
2. **可用性要件（SLA）**: 99.9% / 99.95% / 99.99% / 99.999%
3. **想定トラフィック**: 同時ユーザー数、リクエスト/秒、データ量/日
4. **予算**: 月額予算の目安

### 任意情報
5. **技術スタック**: 言語/フレームワーク、既存の技術制約
6. **データ要件**: DB 種別、データ量、リアルタイム処理要否
7. **セキュリティ要件**: コンプライアンス、データ分類
8. **リージョン**: プライマリ/セカンダリリージョン
9. **CI/CD**: デプロイ戦略の希望

## オーケストレーション手順

### Step 1: 要件構造化
ユーザー入力を以下のカテゴリに整理:
- 機能要件サマリー
- 非機能要件（可用性、性能、セキュリティ、コスト）
- 制約条件

### Step 2: ベースラインアーキテクチャ選定
```
Task: A3. Reference Architecture Matcher
Input: ワークロード種別 + 非機能要件 + 制約
Output: 推奨リファレンスアーキテクチャ + カスタマイズポイント + 技術選択理由
```

### Step 3: 条件分岐による専門分析
| 条件 | 追加エージェント |
|------|----------------|
| SLA 99.99%+ | A11. Mission-Critical Analyst |
| AI/ML ワークロード | A12. AI Workload Architect |

ミッションクリティカルの場合:
```
Task: A11. Mission-Critical Analyst
Input: 可用性要件 + ベースラインアーキテクチャ
Output: スケールユニット設計 + ヘルスモデル + テスト戦略
```

AI ワークロードの場合:
```
Task: A12. AI Workload Architect
Input: AI ユースケース + モデル要件 + データソース
Output: AI アーキテクチャ設計 + Foundry 構成 + ガバナンスポリシー
```

### Step 4: 詳細設計（並列実行）
3つの Task を **同時に** 起動:

```
Task 1: A5. Network Architect
Input: アーキテクチャ設計 + 接続要件
Output: ネットワーク詳細設計

Task 2: A9. DR/HA Planner
Input: SLA 要件 + アーキテクチャ設計
Output: DR/HA 設計 + フェイルオーバー手順

Task 3: A7. Cost Estimator & Optimizer
Input: リソース構成 + トラフィック想定 + 予算
Output: コスト見積もり + 最適化提案
```

### Step 5: IaC コード生成
```
Task: A8. IaC Generator
Input: 確定した設計 + リソース要件
Output: Bicep/Terraform コード + CI/CD パイプライン定義
```

### Step 6: WAF 最終レビュー
```
Task x5: A1. WAF Pillar Analyst（全5柱、並列実行）
Input: 完成したアーキテクチャ設計
Output: 各柱の評価と改善提案
```

### Step 7: 結果統合

## 出力フォーマット

```markdown
# ワークロードアーキテクチャ設計書

## 1. 設計概要
- **ワークロード**: [名称/説明]
- **種別**: [Web / Container / Data / AI / IoT]
- **SLA 目標**: [99.9% / 99.95% / 99.99%]
- **作成日**: YYYY-MM-DD

## 2. アーキテクチャ概要
### 2.1 全体構成
[アーキテクチャの概要説明とテキストダイアグラム]

### 2.2 ベースラインリファレンス
[選定されたリファレンスアーキテクチャとカスタマイズポイント]

### 2.3 技術選択の理由
[各主要コンポーネントの選定理由テーブル]

| コンポーネント | 選択 | 代替候補 | 選定理由 |
|--------------|------|---------|---------|
| Compute | [AKS] | [App Service, Container Apps] | [理由] |
| Database | [Cosmos DB] | [SQL Database, PostgreSQL] | [理由] |
| ... | ... | ... | ... |

## 3. 詳細設計

### 3.1 コンピュート設計
[SKU 選定、スケーリング設計、デプロイ戦略]

### 3.2 データ設計
[データストア設計、データフロー、バックアップ]

### 3.3 ネットワーク設計
[VNet 設計、NSG、Private Endpoint、負荷分散]

### 3.4 ID & アクセス管理
[認証/認可方式、Managed Identity、RBAC]

### 3.5 セキュリティ設計
[暗号化、WAF、DDoS、キー管理]

## 4. DR/HA 設計
- **RPO**: [目標]
- **RTO**: [目標]
[DR 構成、フェイルオーバー手順、テスト計画]

## 5. コスト見積もり
| リソース | SKU | 月額概算 |
|---------|-----|---------|
| ... | ... | ... |
| **合計** | | **$X,XXX/月** |

[最適化オプション: Reserved Instance / Savings Plan / Spot]

## 6. IaC コード
[Bicep/Terraform コードとデプロイ手順]

## 7. WAF レビュー結果
[5柱スコアカード + Top 改善提案]

## 8. 運用設計
[監視、アラート、ログ、スケーリングポリシー]

## 9. 次のステップ
[実装ロードマップ、前提条件]
```

## 知識ファイル参照
- `../../knowledge/reference-architectures-catalog.md` — リファレンスアーキテクチャ一覧
- `../../knowledge/technology-choice-guides.md` — 技術選択ガイド
- `../../knowledge/cloud-design-patterns.md` — クラウドデザインパターン
- `../../knowledge/waf-checklists.md` — WAF チェックリスト
- `../../knowledge/avm-module-catalog.md` — AVM モジュール一覧

## Skill-Agent Invocation Matrix (S4)
| Agent | Required/Conditional |
|-------|---------------------|
| A1. WAF Pillar Analyst | Required |
| A3. Reference Architecture Matcher | Required |
| A5. Network Architect | Required |
| A7. Cost Estimator & Optimizer | Required |
| A8. IaC Generator | Required |
| A9. DR/HA Planner | Required |
| A11. Mission-Critical Analyst | Conditional |
| A12. AI Workload Architect | Conditional |
