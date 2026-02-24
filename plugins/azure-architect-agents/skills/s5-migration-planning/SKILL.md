---
name: s5-migration-planning
description: |
  On-premises or other cloud to Azure migration strategy and execution plan with 5R classification.
  Trigger on: "オンプレからの移行計画を立てて", "既存システムをAzureに移したい",
  "クラウドマイグレーション戦略", "AWSからAzureに移行したい",
  or when users discuss migrating existing systems to Azure.
---

# S5. Migration Planning（移行計画）

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
オンプレミスまたは他クラウドから Azure への移行戦略と実行計画を策定する。5R 分類に基づくワークロード評価、ターゲットアーキテクチャ設計、移行波の定義、ダウンタイム最小化戦略を含む包括的な移行計画を生成。

## トリガー条件
- 「オンプレからの移行計画を立てて」
- 「既存システムを Azure に移したい」
- 「クラウドマイグレーション戦略を策定して」
- 「AWS から Azure に移行したい」

## 入力要件

### 必須情報（AskUserQuestion で収集）
1. **移行元環境**:
   - オンプレミス（Windows Server / Linux / VMware / Hyper-V）
   - 他クラウド（AWS / GCP / その他）
   - コロケーション
2. **対象システムの概要**:
   - サーバー台数（概算）
   - 主要なアプリケーション一覧
   - データ量（TB単位の概算）
3. **移行の動機**:
   - データセンター契約更新（期限あり / なし）
   - コスト削減
   - モダナイゼーション
   - コンプライアンス対応

### 任意情報
4. **システム構成の詳細**: アプリ構成図、依存関係マップ
5. **制約条件**: 予算上限、ダウンタイム許容時間、リージョン制約
6. **既存の Azure 環境**: ランディングゾーンの有無
7. **組織の技術力**: Azure スキルレベル、運用体制
8. **タイムライン**: 移行完了目標時期

## オーケストレーション手順

### Step 1: 現状分析と要件整理
ユーザー入力を構造化:
- 移行元環境のインベントリ
- ビジネス要件と制約
- 技術的な依存関係

### Step 2: CAF 移行フェーズガイダンス
```
Task: A2. CAF Phase Advisor
Input: 現状情報 + 組織状況
Output: Plan/Adopt フェーズのガイダンス + 5R 分類フレームワーク
  - Rehost（リフト&シフト）
  - Refactor（リファクタリング）
  - Rearchitect（再設計）
  - Rebuild（再構築）
  - Replace（SaaS 置換）
```

### Step 3: ターゲットアーキテクチャ選定
```
Task: A3. Reference Architecture Matcher
Input: 各ワークロードの種別 + 非機能要件 + 5R 分類結果
Output: ワークロード別ターゲットアーキテクチャ + 技術選択理由
```

### Step 4: 詳細設計（並列実行）
3つの Task を **同時に** 起動:

```
Task 1: A5. Network Architect
Input: ハイブリッド接続要件 + 移行元ネットワーク構成
Output: ハイブリッド接続設計（ExpressRoute/VPN）+ 移行時の一時的ネットワーク設計

Task 2: A9. DR/HA Planner
Input: 可用性要件 + ダウンタイム許容時間
Output: 移行中の可用性確保計画 + ロールバック計画

Task 3: A7. Cost Estimator & Optimizer
Input: 現行コスト + Azure リソース構成 + 移行ツールコスト
Output: TCO 比較 + 移行コスト + 月額ランニングコスト
```

### Step 5: セキュリティリスク評価
```
Task: A6. Security & Compliance Auditor
Input: 移行計画 + ネットワーク設計 + コンプライアンス要件
Output: 移行時のセキュリティリスク + 緩和策 + コンプライアンスチェック
```

### Step 6: 結果統合と移行計画書生成

## 出力フォーマット

```markdown
# Azure 移行計画書

## 1. エグゼクティブサマリー
- **移行元**: [オンプレ / AWS / GCP]
- **対象規模**: [サーバー数] サーバー、[データ量] TB
- **推奨期間**: [X ヶ月]
- **推定コスト**: 移行費 $XX,XXX + 月額 $X,XXX
- **作成日**: YYYY-MM-DD

## 2. 現状分析

### 2.1 システムインベントリ
| システム名 | 種別 | OS/ミドルウェア | 依存関係 | データ量 |
|-----------|------|---------------|---------|---------|
| ... | ... | ... | ... | ... |

### 2.2 依存関係マップ
[システム間の依存関係図（テキスト表現）]

## 3. 移行戦略（5R 分類）

### 3.1 分類サマリー
| 戦略 | 対象数 | 割合 | 理由 |
|------|-------|------|------|
| Rehost | X | XX% | [即時移行でコスト削減が見込めるもの] |
| Refactor | X | XX% | [PaaS 移行で運用負荷軽減] |
| Rearchitect | X | XX% | [大幅な改善が必要] |
| Rebuild | X | XX% | [レガシーで再構築が効率的] |
| Replace | X | XX% | [SaaS で代替可能] |

### 3.2 ワークロード別移行戦略
[各ワークロードの詳細な移行戦略と理由]

## 4. ターゲットアーキテクチャ
[ワークロード別の Azure ターゲットアーキテクチャ]

## 5. ネットワーク設計

### 5.1 ハイブリッド接続
[ExpressRoute / VPN 設計]

### 5.2 移行時の一時的構成
[移行中のネットワーク構成]

### 5.3 最終的なネットワーク構成
[移行完了後のネットワーク構成]

## 6. 移行波（Migration Waves）

### Wave 0: 基盤準備（Month 1-2）
- Landing Zone 構築
- ネットワーク接続確立
- 移行ツール設定（Azure Migrate / DMS）
- **ゲート条件**: LZ 完成 + 接続テスト OK

### Wave 1: パイロット移行（Month 3）
- 対象: [低リスク・低依存のワークロード]
- 目的: 移行プロセスの検証
- **ゲート条件**: パイロット成功 + 教訓反映

### Wave 2-N: 本番移行（Month 4-X）
- 対象: [依存関係を考慮したグループ]
- 各波のタイムライン、移行手順、ロールバック基準
- **ゲート条件**: 各波の完了基準

### Final Wave: 残余処理とカットオーバー
- DNS 切り替え
- オンプレ環境の縮小/廃止
- ハイバーネーション期間

## 7. ダウンタイム最小化戦略
[移行方式別のダウンタイム分析と緩和策]

| ワークロード | 移行方式 | 想定ダウンタイム | 緩和策 |
|------------|---------|---------------|--------|
| ... | ... | ... | ... |

## 8. セキュリティ
[移行時のリスクと緩和策]

## 9. コスト分析

### 9.1 TCO 比較
| | 現行（年額） | Azure（年額） | 差額 |
|--|------------|-------------|------|
| インフラ | $XXX | $XXX | ... |
| ライセンス | $XXX | $XXX | ... |
| 運用 | $XXX | $XXX | ... |
| **合計** | **$XXX** | **$XXX** | **-XX%** |

### 9.2 移行コスト
[一時的な移行費用の内訳]

## 10. リスクと緩和策
| リスク | 影響度 | 確率 | 緩和策 |
|-------|-------|------|--------|
| ... | ... | ... | ... |

## 11. 成功基準と KPI
[移行成功の定量的基準]

## 12. 次のステップ
[直近のアクションアイテム]
```

## 知識ファイル参照
- `../../knowledge/caf-phases-2025.md` — CAF フェーズ（特に Plan/Adopt）
- `../../knowledge/reference-architectures-catalog.md` — ターゲットアーキテクチャ候補
- `../../knowledge/technology-choice-guides.md` — 技術選択ガイド

## Skill-Agent Invocation Matrix (S5)
| Agent | Required/Conditional |
|-------|---------------------|
| A2. CAF Phase Advisor | Required |
| A3. Reference Architecture Matcher | Required |
| A5. Network Architect | Required |
| A6. Security & Compliance Auditor | Required |
| A7. Cost Estimator & Optimizer | Required |
| A9. DR/HA Planner | Required |
