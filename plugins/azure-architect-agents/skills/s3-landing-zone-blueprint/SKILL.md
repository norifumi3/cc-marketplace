---
name: s3-landing-zone-blueprint
description: |
  Comprehensive Azure Landing Zone (ALZ) design document generation covering all 8 design areas with IaC code output.
  Trigger on: "ランディングゾーンを設計して", "ALZを構築したい", "Azureの基盤環境を作りたい",
  "管理グループの設計をレビューして", or when users discuss Azure foundation/platform infrastructure.
---

# S3. Landing Zone Blueprint（ランディングゾーン設計書）

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
Azure Landing Zone (ALZ) の包括的な設計ドキュメントを生成する。8つの設計領域すべてをカバーし、IaC コードまで出力する。

## トリガー条件
- 「ランディングゾーンを設計して」
- 「ALZ を構築したい」
- 「Azure の基盤環境を作りたい」
- 「管理グループの設計をレビューして」

## 入力要件

### 必須情報（AskUserQuestion で収集）
1. **組織規模**:
   - 小規模（〜50人、サブスクリプション数 〜10）
   - 中規模（50-500人、サブスクリプション数 10-50）
   - 大規模（500人+、サブスクリプション数 50+）
2. **コンプライアンス要件**: ISO 27001 / PCI DSS / HIPAA / NIST / SOC2 / ISMAP / なし
3. **ハイブリッド接続**: オンプレミス接続の要否、既存ネットワーク構成

### 任意情報
4. **IaC ツール選択**: Bicep（推奨）/ Terraform / 未定
5. **既存 Azure 環境**: 既存の管理グループ/サブスクリプションの有無
6. **ワークロード種別**: 予定しているワークロードの概要
7. **AI ワークロード**: AI Landing Zone バリアントの要否
8. **デプロイオプション**: ALZ IaC Accelerator / AVM / Portal

## オーケストレーション手順

### Step 1: 要件整理と設計方針決定
ユーザー入力を構造化し、以下の設計方針を確定:
- 管理グループ階層のパターン（標準 / カスタム）
- ネットワークトポロジー（Hub-Spoke / VWAN / なし）
- セキュリティベースライン（Azure Security Benchmark / CIS / カスタム）

### Step 2: ランディングゾーン全体設計
```
Task: A4. Landing Zone Designer
Input: 組織要件 + 設計方針
Output: 8設計領域の全体設計
  - A: Billing and Microsoft Entra ID tenant
  - B: Identity and access management
  - C: Resource organization (Management Groups + Subscriptions)
  - D: Network topology and connectivity
  - E: Security
  - F: Management and monitoring
  - G: Governance (Azure Policy)
  - H: Platform automation and DevOps
```

### Step 3: 詳細設計（並列実行）
3つの Task を **同時に** 起動:

```
Task 1: A5. Network Architect
Input: Design Area D の要件 + ハイブリッド接続要件
Output: ネットワーク詳細設計（トポロジー、CIDR、NSG/UDR、DNS）

Task 2: A6. Security & Compliance Auditor
Input: Design Area E の要件 + コンプライアンス要件
Output: セキュリティ設計検証 + Policy 推奨

Task 3: A7. Cost Estimator & Optimizer
Input: 全体設計 + 想定リソース
Output: 月額コスト見積もり + 最適化提案
```

### Step 4: IaC コード生成
```
Task: A8. IaC Generator
Input: 全体設計 + 詳細設計結果 + IaC ツール選択
Output: AVM ベースの Bicep/Terraform コード
```

### Step 5: WAF レビュー
```
Task: A1. WAF Pillar Analyst (全柱)
Input: 完成した LZ 設計
Output: WAF 観点でのレビュー結果
```

### Step 6: 結果統合

## 出力フォーマット

```markdown
# Azure Landing Zone 設計書

## 1. 設計概要
- **組織**: [組織名/プロジェクト名]
- **規模**: [小/中/大]
- **作成日**: YYYY-MM-DD
- **IaC ツール**: [Bicep/Terraform]

## 2. 管理グループ階層

Tenant Root Group
└── [Organization]
    ├── Platform
    │   ├── Identity
    │   ├── Management
    │   ├── Connectivity
    │   └── Security          ← 2025年新設
    ├── Landing Zones
    │   ├── Corp
    │   ├── Online
    │   └── [Custom]
    ├── Sandbox
    └── Decommissioned

## 3. サブスクリプション設計
[各管理グループ配下のサブスクリプション一覧と用途]

## 4. ネットワーク設計
### 4.1 トポロジー
[Hub-Spoke / VWAN の図と説明]
### 4.2 IP アドレス設計
[CIDR 計画]
### 4.3 DNS 設計
[Private DNS Zone 設計]
### 4.4 接続設計
[ExpressRoute / VPN / Private Link]

## 5. ID & アクセス管理
[Entra ID 設計、RBAC モデル、PIM 設定]

## 6. セキュリティ設計
[Security Benchmark 準拠状況、Defender for Cloud 設定]

## 7. ガバナンス（Azure Policy）
[Policy 一覧: 名前、効果、スコープ]

## 8. 管理・監視
[Log Analytics、Azure Monitor 設計]

## 9. 命名規則・タグ規約
[命名規則テーブル、必須タグ一覧]

## 10. コスト見積もり
[月額見積もり、最適化オプション]

## 11. IaC コード
[Bicep/Terraform コードとデプロイ手順]

## 12. WAF レビュー結果
[WAF 5柱の評価サマリー]

## 13. デプロイ手順
[段階的なデプロイステップ]
```

## 知識ファイル参照
- `../../knowledge/alz-design-areas.md` — ALZ 8 設計領域の詳細
- `../../knowledge/avm-module-catalog.md` — AVM モジュール一覧
- `../../knowledge/waf-checklists.md` — WAF チェックリスト

## Skill-Agent Invocation Matrix (S3)
| Agent | Required/Conditional |
|-------|---------------------|
| A1. WAF Pillar Analyst | Required |
| A4. Landing Zone Designer | Required |
| A5. Network Architect | Required |
| A6. Security & Compliance Auditor | Required |
| A7. Cost Estimator & Optimizer | Required |
| A8. IaC Generator | Required |
