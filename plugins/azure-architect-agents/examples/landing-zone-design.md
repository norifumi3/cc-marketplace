# 使用例: ランディングゾーン設計 (S3)

## シナリオ
中規模企業（200名）が Azure 環境を新規構築する。

## ユーザー入力例

```
当社のAzureランディングゾーンを設計してください。

## 組織情報
- 従業員数: 200名
- IT チーム: 10名（インフラ5名、開発5名）
- Azure 経験: 初期段階（一部 PoC 実施済み）

## 要件
- コンプライアンス: ISO 27001 準拠が必要
- オンプレミス: 東京データセンターとの VPN 接続が必要
- ワークロード: 社内 Web アプリ(3つ)、外部公開 API(1つ)
- リージョン: Japan East（プライマリ）、Japan West（DR）
- IaC: Bicep を希望

## 予算
- 月額インフラ予算: 50万円（約 $3,500）
```

## 期待される実行フロー

### Step 1: 要件整理
- 規模: 中規模
- コンプライアンス: ISO 27001
- ハイブリッド: VPN 接続あり
- IaC: Bicep

### Step 2: A4 (Landing Zone Designer) 起動

**期待される設計出力**:

#### 管理グループ階層
```
Tenant Root Group
└── Contoso
    ├── Platform
    │   ├── Identity         # (Subscription: sub-identity-prod)
    │   ├── Management       # (Subscription: sub-management-prod)
    │   └── Connectivity     # (Subscription: sub-connectivity-prod)
    ├── Landing Zones
    │   ├── Corp             # (Subscription: sub-corp-webapp-prod, sub-corp-webapp-dev)
    │   └── Online           # (Subscription: sub-online-api-prod)
    └── Sandbox              # (Subscription: sub-sandbox-001)
```
※ 200名規模では Security 管理グループは省略可能（Platform/Management に統合）

#### サブスクリプション設計
| 管理グループ | サブスクリプション | 用途 |
|------------|-------------------|------|
| Identity | sub-identity-prod | AD DS VM, Entra Connect |
| Management | sub-management-prod | Log Analytics, Automation, Backup |
| Connectivity | sub-connectivity-prod | Hub VNet, VPN Gateway, Firewall, DNS |
| Corp | sub-corp-webapp-prod | 社内 Web アプリ（本番） |
| Corp | sub-corp-webapp-dev | 社内 Web アプリ（開発） |
| Online | sub-online-api-prod | 外部公開 API（本番） |
| Sandbox | sub-sandbox-001 | 実験・学習用 |

### Step 3: A5 (Network Architect) 並列起動

**期待される出力**:

#### ネットワーク設計
```
Hub VNet: 10.0.0.0/16 (Japan East)
├── AzureFirewallSubnet: 10.0.0.0/24
├── GatewaySubnet: 10.0.1.0/24
├── AzureBastionSubnet: 10.0.2.0/24
└── ManagementSubnet: 10.0.3.0/24

Spoke-Corp VNet: 10.1.0.0/16
├── WebAppSubnet: 10.1.0.0/24
├── AppSubnet: 10.1.1.0/24
├── DbSubnet: 10.1.2.0/24
└── PrivateEndpointSubnet: 10.1.3.0/24

Spoke-Online VNet: 10.2.0.0/16
├── ApiSubnet: 10.2.0.0/24
├── BackendSubnet: 10.2.1.0/24
└── PrivateEndpointSubnet: 10.2.2.0/24

DR Hub VNet: 10.10.0.0/16 (Japan West)
└── (ミニマム構成、DR 時にスケール)

VPN 接続:
  Tokyo DC (172.16.0.0/12) ←→ Hub VNet (S2S VPN, Active-Passive)
```

### Step 4: A6 (Security Auditor) 並列起動

**ISO 27001 対応の主要ポリシー**:
- A.9 アクセス制御 → RBAC + PIM + 条件付きアクセス
- A.10 暗号化 → CMK + TDE + TLS 1.2 強制
- A.12 運用 → Azure Monitor + Defender + Update Manager
- A.14 開発 → DevSecOps、コードスキャン

### Step 5: A7 (Cost Estimator) 並列起動

**月額見積もり**:
| カテゴリ | リソース | 月額概算 |
|---------|---------|---------|
| Connectivity | VPN Gateway (VpnGw1) | ¥20,000 |
| Connectivity | Azure Firewall (Basic) | ¥50,000 |
| Management | Log Analytics (50GB/日) | ¥30,000 |
| Security | Defender for Cloud | ¥15,000 |
| Network | Azure Bastion (Basic) | ¥20,000 |
| 予備 | | ¥15,000 |
| **合計** | | **¥150,000** |
※ ワークロードリソースは別途

### Step 6: A8 (IaC Generator) 起動
AVM Bicep モジュールでの LZ デプロイコード生成

### Step 7: A1 (WAF Pillar Analyst) 起動
LZ 設計全体の WAF レビュー

## 期待されるデプロイ手順

```
Phase 1: Platform 基盤 (Week 1-2)
  1. 管理グループ階層の作成
  2. Management サブスクリプション: Log Analytics, Automation
  3. Identity サブスクリプション: Entra Connect (必要な場合)

Phase 2: ネットワーク (Week 3-4)
  4. Connectivity サブスクリプション: Hub VNet, VPN Gateway
  5. Azure Firewall の構成
  6. VPN 接続の確立とテスト
  7. Private DNS Zone の構成

Phase 3: セキュリティ & ガバナンス (Week 5)
  8. Azure Policy の適用
  9. Defender for Cloud の有効化
  10. RBAC ロールの割り当て

Phase 4: Landing Zone (Week 6)
  11. Corp/Online サブスクリプションの作成
  12. Spoke VNet のデプロイとピアリング
  13. NSG/UDR の設定

Phase 5: 検証 (Week 7-8)
  14. 接続テスト（VPN、DNS、ピアリング）
  15. Policy 準拠テスト
  16. セキュリティスキャン
```
