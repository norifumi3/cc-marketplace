# Cloud Adoption Framework (CAF) フェーズ詳細 — 2025年版

## 概要
Microsoft Cloud Adoption Framework for Azure は、クラウド採用のライフサイクル全体をガイドするフレームワーク。7つのフェーズで構成される。

## 7 フェーズ

### 1. Strategy（戦略）
**目的**: クラウド採用の動機とビジネス成果を明確化

#### 主要成果物
- クラウド採用動機の文書化
  - 移行トリガー: DC 契約更新、コスト削減、コンプライアンス
  - イノベーショントリガー: 市場投入速度、顧客体験、新製品
- ビジネス成果の定義
  - 財務: TCO 削減、収益向上
  - アジリティ: 市場投入速度、スケーラビリティ
  - リーチ: グローバル展開、規制対応
- ビジネスケースの作成
  - 現状コスト分析
  - Azure 移行後のコスト予測
  - ROI 計算
- 最初のプロジェクトの選定

#### AI Strategy（AI 戦略）
- AI ユースケースの特定と優先順位付け
- AI 成熟度評価
- AI ROI 分析
- Responsible AI フレームワークの採用

---

### 2. Plan（計画）
**目的**: デジタル資産の評価とクラウド採用計画の策定

#### 主要成果物
- デジタル資産棚卸し
  - サーバー、アプリ、データベースのインベントリ
  - 依存関係マッピング
  - Azure Migrate Assessment
- 合理化（5R 分類）
  - **Rehost**: IaaS への直接移行
  - **Refactor**: PaaS へのリファクタリング（最小限の変更）
  - **Rearchitect**: クラウドネイティブへの再設計
  - **Rebuild**: フルリビルド
  - **Replace**: SaaS への置換
- クラウド採用計画
  - 移行波の定義
  - タイムライン
  - リソース計画
- スキルギャップ分析
  - 必要なスキルの特定
  - トレーニング計画
- 組織の整合性
  - RACI マトリクス
  - CCoE（Cloud Center of Excellence）設置計画

#### AI Plan
- AI プラットフォーム計画
- データ戦略と準備
- AI チーム構成
- AI ツールチェーン選定

---

### 3. Ready（準備）
**目的**: Azure 環境（Landing Zone）の構築

#### 主要成果物
- Azure Landing Zone 設計（8設計領域）
  - A: Billing & Tenant
  - B: Identity & Access
  - C: Resource Organization
  - D: Network Topology
  - E: Security
  - F: Management
  - G: Governance
  - H: Platform Automation
- Landing Zone デプロイ
  - ALZ IaC Accelerator
  - AVM Bicep/Terraform
- 管理グループ階層
- ネットワーク接続確立
- ID 基盤構築
- Policy ベースライン適用

#### AI Ready
- AI Landing Zone の構築
- Azure AI Foundry Hub/Project の設定
- AI ネットワーク分離
- AI データパイプライン基盤

---

### 4. Adopt（採用）
**目的**: ワークロードの移行またはイノベーション

#### 移行（Migrate）
- Azure Migrate の設定・実行
- 評価（Assessment）の実施
- 移行（Migration）の実行
  - VM → Azure VM（ASR）
  - DB → Azure SQL / Cosmos DB（DMS）
  - Web App → App Service
- 最適化（Optimization）
  - SKU 最適化
  - コスト最適化
- 昇格（Promote）
  - 本番カットオーバー
  - 監視設定
  - バックアップ設定

#### イノベーション（Innovate）
- ビジネス価値のコンセンサス
- MVP の構築
- デジタル発明
  - アプリケーションのモダナイゼーション
  - データの民主化
  - AI/ML の統合
  - クラウドネイティブ開発

---

### 5. Govern（統治）
**目的**: ガバナンスの確立と継続的改善

#### 2024年大幅刷新の内容
- ガバナンス規律の再構成
- Azure Policy の体系化
- コスト管理の強化

#### 主要成果物
- ガバナンスベンチマーク
- ガバナンス MVP
- 5つの規律:
  1. **Cost Management**: 予算、アラート、最適化
  2. **Security Baseline**: セキュリティポリシー、ベンチマーク
  3. **Identity Baseline**: RBAC、PIM、条件付きアクセス
  4. **Resource Consistency**: 命名規則、タグ、ロック
  5. **Deployment Acceleration**: IaC、CI/CD、Policy as Code

#### AI Govern
- Responsible AI ポリシー
- AI モデルガバナンス
- AI コスト管理
- AI データガバナンス

---

### 6. Secure（セキュリティ）
**目的**: セキュリティ体制の確立（Govern から独立したフェーズ）

#### 2025年更新: Security 管理グループ/サブスクリプション新設
```
Platform
├── Identity
├── Management
├── Connectivity
└── Security          ← NEW: セキュリティ専用
    ├── Sentinel
    ├── Defender for Cloud (集中管理)
    └── Security Operations
```

#### 主要成果物
- セキュリティベースラインの定義
- ゼロトラスト実装
  - ID: MFA + PIM + 条件付きアクセス
  - デバイス: Intune + Compliance
  - ネットワーク: マイクロセグメンテーション
  - アプリ: Managed Identity + Private Endpoint
  - データ: 暗号化 + 分類 + DLP
- Microsoft Defender for Cloud 構成
- Microsoft Sentinel 構成
- セキュリティ運用プロセス

#### AI Secure
- AI モデルのセキュリティ
- Prompt Injection 対策
- Content Safety 設定
- AI データ保護

---

### 7. Manage（管理）
**目的**: 運用の確立と最適化

#### 2025年刷新の内容
- 運用ベースラインの再定義
- Azure Monitor の統合強化
- AIOps の導入

#### 主要成果物
- 管理ベースライン
  - Azure Monitor 設定
  - Log Analytics ワークスペース
  - アラートルール
  - Azure Update Manager
- ビジネスアラインメント
  - SLA/SLO の定義
  - サービスカタログ
  - インシデント管理プロセス
- 運用コンプライアンス
  - パッチ管理
  - バックアップ管理
  - 構成管理
- 保護と復旧
  - DR 計画
  - バックアップテスト
  - インシデント対応
- プラットフォーム運用最適化
  - 自動化
  - FinOps
  - 継続的改善

---

## フェーズ間の関係

```
Strategy → Plan → Ready → Adopt
                    ↑         │
                    │         ▼
              Govern ← ─ ─ Secure
                    ↑         │
                    │         ▼
                   Manage ← ─ ┘
```

- Strategy/Plan/Ready/Adopt は順序的に進行
- Govern/Secure/Manage は並行して継続的に改善
- 各フェーズは反復的（一度で完了ではなく継続的に成熟）

## CAF ツールキット
- **Cloud Adoption Strategy Evaluator**: 戦略評価ツール
- **Governance Benchmark**: ガバナンス成熟度評価
- **Azure Migrate**: 移行ツール
- **Azure Well-Architected Review**: ワークロード評価
- **Total Cost of Ownership Calculator**: TCO 計算ツール
