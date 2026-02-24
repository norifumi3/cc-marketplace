# Azure Landing Zone (ALZ) 設計領域 — 2025年版

## 概要
Azure Landing Zone は 8 つの設計領域で構成される Azure 環境の基盤設計フレームワーク。

## 管理グループ階層（2025年版）

```
Tenant Root Group
└── [Organization]                    # 組織ルート
    ├── Platform                      # プラットフォーム
    │   ├── Identity                  # ID 管理（AD DS, Entra ID DS）
    │   ├── Management                # 管理（Log Analytics, Automation）
    │   ├── Connectivity              # 接続（Hub VNet, Firewall, VPN/ER）
    │   └── Security                  # セキュリティ（Sentinel, Defender） ← 2025年新設
    ├── Landing Zones                 # ワークロード
    │   ├── Corp                      # 内部向け（Private Endpoint, 社内接続）
    │   ├── Online                    # 公開向け（インターネット公開サービス）
    │   └── [Custom]                  # カスタム（Confidential, SAP 等）
    ├── Sandbox                       # サンドボックス（実験・学習用）
    └── Decommissioned                # 廃止予定（削除待ちリソース）
```

---

## Design Area A: Billing and Microsoft Entra ID tenant

### テナント戦略
| パターン | 適用ケース |
|---------|-----------|
| シングルテナント | ほとんどの組織（推奨） |
| マルチテナント | M&A、独立した事業体、強い分離要件 |

### 課金モデル
| モデル | 特徴 |
|-------|------|
| EA (Enterprise Agreement) | 大企業向け、Volume Licensing |
| MCA (Microsoft Customer Agreement) | 中小企業、直接契約 |
| CSP (Cloud Solution Provider) | パートナー経由 |

### サブスクリプション戦略
- **目的別分離**: Platform / Workload / Sandbox
- **Subscription Vending**: 自動化されたサブスクリプション作成
- **制限の考慮**: サブスクリプションあたりのリソース制限

---

## Design Area B: Identity and access management

### ID 基盤
| コンポーネント | 用途 |
|-------------|------|
| Microsoft Entra ID | クラウドネイティブ ID |
| Entra Connect Sync | オンプレ AD との同期 |
| Entra Domain Services | レガシー AD DS 機能 |
| Entra External ID | 外部ユーザー（B2B/B2C） |

### 認証方式
| 方式 | セキュリティ | 複雑度 | 推奨 |
|------|-----------|--------|------|
| PHS (Password Hash Sync) | 中 | 低 | 推奨（基本） |
| PTA (Pass-through Auth) | 高 | 中 | オンプレ認証必須時 |
| Federation (ADFS) | 高 | 高 | 非推奨（レガシー） |

### RBAC 設計
- **Built-in Roles**: Owner / Contributor / Reader / User Access Admin
- **カスタムロール**: 最小権限の原則に基づき定義
- **PIM (Privileged Identity Management)**: 特権ロールの Just-In-Time 有効化
- **ブレークグラスアカウント**: 緊急時用の常時有効なグローバル管理者（MFA なし、厳重監査）

### 条件付きアクセス ベースラインポリシー
1. 全ユーザーに MFA を要求
2. レガシー認証のブロック
3. 管理者に強力な MFA を要求
4. リスクベースのアクセス制御
5. デバイスコンプライアンスの要求
6. 信頼されたロケーションの定義

---

## Design Area C: Resource organization

### 管理グループの Azure Policy 割り当て

| 管理グループ | 主要ポリシー |
|------------|------------|
| Organization (Root) | 許可リージョンの制限、必須タグの強制 |
| Platform | 診断設定の強制、パブリック IP の制限 |
| Identity | Entra ID 関連の監査ポリシー |
| Management | Log Analytics の設定強制 |
| Connectivity | ネットワーク関連のポリシー |
| Security | Defender/Sentinel の設定強制 |
| Landing Zones | WAF 準拠ポリシー、暗号化強制 |
| Corp | パブリックアクセスの拒否、Private Endpoint 強制 |
| Online | WAF/DDoS の強制 |
| Sandbox | コスト制限、リソース種別制限 |
| Decommissioned | 新規リソース作成の拒否 |

### 命名規約
```
{resourceType}-{workload}-{environment}-{region}-{instance}

例:
  rg-webapp-prod-japaneast-001          # Resource Group
  vnet-hub-prod-japaneast-001           # Virtual Network
  vm-web-prod-japaneast-001             # Virtual Machine
  sql-orders-prod-japaneast-001         # SQL Database
  kv-webapp-prod-japaneast-001          # Key Vault
  st-datawebapp-prod-japaneast-001      # Storage Account (制限あり)
```

### 必須タグ
| タグ名 | 用途 | 例 |
|-------|------|-----|
| CostCenter | コスト配賦 | CC-12345 |
| Environment | 環境区分 | prod / staging / dev |
| Owner | 所有者 | team-name / user@email |
| Application | アプリケーション名 | webapp-orders |
| DataClassification | データ分類 | Public / Internal / Confidential |

---

## Design Area D: Network topology and connectivity

### トポロジーオプション
| オプション | 適用ケース | 管理 |
|-----------|-----------|------|
| Hub-Spoke (Azure Firewall) | 中小規模、カスタマイズ重視 | 自己管理 |
| Hub-Spoke (NVA) | 既存 NVA 資産の活用 | 自己管理 |
| Virtual WAN (Standard) | 大規模、マルチリージョン | マネージド |
| No Hub (VNet のみ) | 小規模、PoC | 自己管理 |

### ネットワーク設計コンポーネント
- **Hub VNet**: Azure Firewall + VPN/ER Gateway + Bastion
- **Spoke VNet**: ワークロードリソース + Private Endpoint
- **Private DNS Zone**: PaaS サービスのプライベート名前解決
- **DNS Private Resolver**: ハイブリッド DNS
- **DDoS Protection**: Standard プラン（推奨）
- **Network Watcher**: ネットワーク診断

---

## Design Area E: Security

### セキュリティサービス階層
```
Layer 1: Identity Security
  └── Entra ID + MFA + PIM + Conditional Access

Layer 2: Network Security
  └── NSG + Azure Firewall + DDoS + Private Endpoint

Layer 3: Data Security
  └── Encryption (at-rest + in-transit) + Key Vault + CMK

Layer 4: Application Security
  └── WAF + Managed Identity + App Service Auth

Layer 5: Detection & Response
  └── Defender for Cloud + Sentinel + Threat Protection
```

### Microsoft Defender for Cloud プラン
| プラン | 保護対象 |
|-------|---------|
| Defender for Servers | VM、Arc サーバー |
| Defender for Storage | Storage Account |
| Defender for SQL | SQL Database、MI |
| Defender for Containers | AKS、ACR |
| Defender for App Service | App Service |
| Defender for Key Vault | Key Vault |
| Defender for DNS | DNS クエリ |
| Defender for Resource Manager | ARM 操作 |

---

## Design Area F: Management and monitoring

### 監視設計
- **Log Analytics Workspace**: 集中型 or 分散型
- **Azure Monitor Agent (AMA)**: 統一エージェント
- **Data Collection Rules (DCR)**: データ収集ルール
- **Azure Workbook**: カスタムダッシュボード
- **Azure Advisor**: 推奨事項

### 管理ツール
| ツール | 用途 |
|-------|------|
| Azure Update Manager | パッチ管理 |
| Azure Automation | Runbook 自動化 |
| Azure Backup | バックアップ管理 |
| Azure Site Recovery | DR |
| Azure Arc | ハイブリッド管理 |

---

## Design Area G: Governance

### Azure Policy 効果
| 効果 | 用途 | 適用タイミング |
|------|------|-------------|
| **Audit** | 非準拠を記録（ブロックしない） | 初期評価 |
| **Deny** | 非準拠のリソース作成をブロック | 本番環境 |
| **DeployIfNotExists** | 不足設定を自動デプロイ | 診断設定等 |
| **Modify** | 既存リソースを修正 | タグの自動付与 |
| **Append** | リソースにプロパティを追加 | ネットワークルール |

### ALZ デフォルトポリシー（主要）
- 許可されたリージョンの制限
- 許可されたリソース種別の制限
- 必須タグの強制
- 診断設定の自動デプロイ
- 暗号化の強制
- パブリック IP の制限
- ネットワーク制限の強制

---

## Design Area H: Platform automation and DevOps

### デプロイオプション比較
| オプション | 速度 | カスタマイズ | 学習コスト |
|-----------|------|------------|-----------|
| ALZ IaC Accelerator | 最速 | 中 | 低 |
| AVM Bicep | 中 | 高 | 中 |
| AVM Terraform | 中 | 高 | 中 |
| Azure Portal | 最速 | 低 | 最低 |
| ARM Templates | 遅 | 高 | 高（非推奨） |

### CI/CD パイプライン
- **GitHub Actions**: GitHub リポジトリ向け
- **Azure DevOps Pipelines**: Azure DevOps 向け
- **状態管理**: Terraform State (Azure Storage) / Bicep Deployment Stack
