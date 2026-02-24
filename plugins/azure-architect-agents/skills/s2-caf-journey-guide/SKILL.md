---
name: s2-caf-journey-guide
description: |
  Cloud Adoption Framework (CAF) maturity assessment and next-step roadmap guidance.
  Trigger on: "CAFのどのフェーズ？", "クラウド移行の計画", "クラウド採用の成熟度を評価",
  "ガバナンスを強化したい", or when users discuss cloud adoption strategy and organizational readiness.
---

# S2. CAF Journey Guide（CAF ジャーニーガイド）

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
Cloud Adoption Framework (CAF) に基づき、組織のクラウド採用の現在地を評価し、次のステップへのロードマップを提供する。

## トリガー条件
- 「CAF のどのフェーズにいる？」
- 「クラウド移行の計画を立てたい」
- 「クラウド採用の成熟度を評価して」
- 「ガバナンスを強化したい」

## 入力要件

### 必須情報（AskUserQuestion で収集）
1. **現在の状況**: クラウド利用状況（未使用 / PoC / 一部本番 / 大規模展開）
2. **組織規模**: チーム人数、IT 部門の体制
3. **主な目的**: コスト削減 / イノベーション / スケーラビリティ / コンプライアンス対応

### 任意情報
4. **既存のクラウド資産**: 利用中の Azure サービス、サブスクリプション数
5. **課題・懸念**: セキュリティ、コスト、スキル不足、組織の抵抗
6. **AI 活用意向**: AI/ML ワークロードの計画有無

## オーケストレーション手順

### Step 1: フェーズ判定ヒアリング
AskUserQuestion を使用して以下を構造的に収集:

```
Q1: クラウド採用の段階は？
  - まだ検討段階（Strategy）
  - 計画を立てている（Plan）
  - 環境を準備中（Ready）
  - ワークロードを移行/構築中（Adopt）
  - ガバナンスを整備中（Govern）
  - セキュリティを強化中（Secure）
  - 運用を最適化中（Manage）

Q2: 以下はどの程度完了していますか？
  - クラウド戦略ドキュメント: [未着手/作成中/完了]
  - デジタル資産の棚卸し: [未着手/作成中/完了]
  - ランディングゾーン: [未構築/構築中/運用中]
  - ワークロード移行/開発: [未着手/進行中/大部分完了]
  - ガバナンスポリシー: [未定義/一部定義/体系化済み]
  - 監視・運用体制: [未整備/一部整備/成熟]
```

### Step 2: CAF フェーズ成熟度評価
```
Task: A2. CAF Phase Advisor
Input: ヒアリング結果 + 組織情報
Output: 現在フェーズの成熟度（5段階）+ 未完了成果物 + 次フェーズの準備度
```

### Step 3: フェーズ別専門分析（条件分岐）

| 現在フェーズ | 起動エージェント | 目的 |
|------------|----------------|------|
| Strategy/Plan | （追加エージェントなし） | A2 のアドバイスで十分 |
| Ready | A4. Landing Zone Designer | LZ 設計の評価と推奨 |
| Adopt（移行） | A3. Reference Architecture Matcher | ターゲットアーキテクチャの選定 |
| Adopt（構築） | A3 + A8. IaC Generator | アーキテクチャ選定 + IaC 生成 |
| Govern | A6. Security Auditor | ガバナンスポリシーの評価 |
| Secure | A6. Security Auditor | セキュリティ体制の評価 |
| Manage | A10. Monitoring Designer + A7. Cost Estimator | 運用成熟度の評価 |

### Step 4: 成果物ギャップ分析
CAF の各フェーズで期待される成果物のチェックリストに基づき、未完了項目を特定。

### Step 5: ロードマップ生成

## 出力フォーマット

```markdown
# CAF ジャーニー評価レポート

## エグゼクティブサマリー
- **現在のフェーズ**: [フェーズ名]
- **成熟度レベル**: [★★★☆☆] (3/5)
- **評価日**: YYYY-MM-DD

## フェーズ成熟度マップ

| フェーズ | 成熟度 | ステータス |
|---------|--------|-----------|
| Strategy | ★★★★★ | 完了 |
| Plan | ★★★★☆ | 概ね完了 |
| Ready | ★★★☆☆ | 進行中 ← 現在地 |
| Adopt | ★☆☆☆☆ | 未着手 |
| Govern | ★★☆☆☆ | 一部着手 |
| Secure | ★☆☆☆☆ | 未着手 |
| Manage | ★☆☆☆☆ | 未着手 |

## 成果物チェックリスト

### [現在フェーズ名] の成果物
- [x] 完了済み成果物1
- [ ] 未完了成果物2 — **推奨アクション**: ...
- [ ] 未完了成果物3 — **推奨アクション**: ...

### 次フェーズの準備状況
- 準備度: [%]
- 前提条件の充足状況

## 推奨アクション（優先順位付き）

### 短期（1-3ヶ月）
1. [アクション] — 理由と期待効果

### 中期（3-6ヶ月）
1. [アクション] — 理由と期待効果

### 長期（6-12ヶ月）
1. [アクション] — 理由と期待効果

## ロードマップ

Phase 1 (Month 1-3): [Ready フェーズ完了]
  - LZ 設計・構築
  - Policy 定義
  - ネットワーク接続

Phase 2 (Month 4-6): [Adopt フェーズ開始]
  - パイロット移行
  - Well-Architected レビュー
  - 運用手順整備

Phase 3 (Month 7-12): [Govern + Manage]
  - ガバナンス体系化
  - 監視・アラート整備
  - FinOps 導入

## AI 採用ガイダンス（該当する場合）
[AI Strategy → AI Plan → AI Ready → AI Govern → AI Secure のマッピング]

## 参考リソース
[フェーズに応じた Microsoft Learn / CAF ドキュメントリンク]
```

## 知識ファイル参照
- `../../knowledge/caf-phases-2025.md` — CAF 7 フェーズ詳細
- `../../knowledge/alz-design-areas.md` — Landing Zone 設計領域（Ready フェーズ用）

## Skill-Agent Invocation Matrix (S2)
| Agent | Required/Conditional |
|-------|---------------------|
| A2. CAF Phase Advisor | Required |
| A3. Reference Architecture Matcher | Conditional |
| A4. Landing Zone Designer | Conditional |
| A6. Security & Compliance Auditor | Conditional |
| A7. Cost Estimator & Optimizer | Conditional |
| A8. IaC Generator | Conditional |
| A10. Monitoring & Observability Designer | Conditional |
