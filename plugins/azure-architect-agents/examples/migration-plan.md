# 使用例: 移行計画 (S5)

## シナリオ
製造業の社内システムをオンプレミスから Azure に移行する。

## ユーザー入力例

```
オンプレミスの社内システムを Azure に移行する計画を立ててください。

## 現行環境
- データセンター: 東京（契約残り2年）
- VMware vSphere 7.0
- サーバー台数: 約30台

### 主要システム
1. 社内ポータル (IIS + .NET Framework 4.8 + SQL Server 2016)
   - ユーザー数: 500名
   - 可用性: 営業時間のみ（99.5%で可）

2. 生産管理システム (Java + PostgreSQL)
   - 24/365 稼働
   - 可用性: 99.9%
   - オンプレ設備とのリアルタイム連携あり

3. ファイルサーバー (Windows Server + SMB共有)
   - データ量: 5TB
   - 全社員がアクセス

4. Active Directory (DC × 2台)
   - オンプレ AD DS

5. メールサーバー (Exchange 2016)
   - 500 ユーザー

## 制約
- 予算: 移行費用 1000万円以内
- ダウンタイム: 生産管理は最大4時間
- スキル: Azure 初心者チーム（3名）
- タイムライン: 12ヶ月以内に完了
```

## 期待される実行フロー

### Step 2: A2 (CAF Phase Advisor) — 5R 分類結果

| システム | 推奨戦略 | 理由 |
|---------|---------|------|
| 社内ポータル | **Refactor** | .NET Framework → .NET 8 + App Service への PaaS 移行 |
| 生産管理 | **Rehost** (初期) → **Refactor** (後期) | オンプレ連携のため段階移行 |
| ファイルサーバー | **Replace** | Azure Files or SharePoint Online |
| Active Directory | **Rehost + 拡張** | Entra Connect で同期、段階的に Entra ID 移行 |
| メールサーバー | **Replace** | Microsoft 365 (Exchange Online) |

### Step 3: A3 (Reference Architecture Matcher)

| システム | ターゲットアーキテクチャ |
|---------|---------------------|
| 社内ポータル | Reliable Web App Pattern (App Service + SQL Database) |
| 生産管理 | Hybrid Architecture (VM + ExpressRoute/VPN → 後期 AKS) |
| ファイルサーバー | Azure Files (Premium, SMB) |
| AD | Hybrid Identity (Entra Connect Sync + PHS) |
| メール | Microsoft 365 |

### Step 4: 並列実行

#### A5 (Network Architect) — ハイブリッド接続設計
```
Phase 1: VPN 接続（移行開始時）
  Tokyo DC ←→ Hub VNet (S2S VPN, 1Gbps)
  コスト: 約 ¥30,000/月

Phase 2: 本番移行時（生産管理向け）
  Tokyo DC ←→ Hub VNet (ExpressRoute 200Mbps)
  コスト: 約 ¥150,000/月（回線 + ピアリング）
  ※ 生産管理のリアルタイム連携には低レイテンシが必要

Phase 3: 移行完了後
  ExpressRoute → VPN にダウングレード（コスト最適化）
  ※ オンプレ設備連携が残る場合は ExpressRoute 維持
```

#### A9 (DR/HA Planner) — 移行時の可用性確保
- 社内ポータル: メンテナンスウィンドウ（土曜夜間、4時間）で切り替え
- 生産管理: Blue-Green 方式（並行稼働期間を設定、DNS 切り替え）
- ファイルサーバー: Azure File Sync でオンライン同期（ダウンタイムなし）
- AD: Entra Connect の段階的同期（ダウンタイムなし）
- メール: Microsoft 365 のハイブリッド移行（段階的、ダウンタイムなし）

#### A7 (Cost Estimator) — コスト分析

**移行コスト（一時費用）**:
| 項目 | 費用概算 |
|------|---------|
| Azure Migrate ツール | ¥0（無料） |
| ExpressRoute 初期費用 | ¥200,000 |
| Microsoft 365 移行ツール | ¥0（含まれる） |
| 外部コンサルティング | ¥3,000,000 |
| トレーニング費用 | ¥500,000 |
| 並行稼働期間のインフラ費用 | ¥1,500,000（3ヶ月分） |
| **移行費用合計** | **¥5,200,000** |

**月額ランニングコスト比較**:
| | 現行（月額） | Azure（月額） | 差額 |
|--|-----------|------------|------|
| インフラ | ¥800,000 | ¥350,000 | -¥450,000 |
| ライセンス | ¥400,000 | ¥300,000 | -¥100,000 |
| 運用 | ¥600,000 | ¥400,000 | -¥200,000 |
| **合計** | **¥1,800,000** | **¥1,050,000** | **-¥750,000** |

### Step 5: A6 (Security Auditor)
移行時のリスク:
1. 移行中のデータ漏洩リスク → VPN 暗号化 + データ転送の暗号化
2. 並行稼働期間のアタックサーフェス拡大 → 一時的 NSG 強化
3. AD 同期時の認証情報漏洩 → PHS (パスワードハッシュ同期) の安全性確認

## 期待される移行波

```
Wave 0: 基盤構築 (Month 1-2)
├── Landing Zone 構築
├── VPN 接続確立
├── Entra Connect 設定（AD 同期開始）
├── Azure Migrate 設定
└── Gate: 接続テスト OK, AD 同期 OK

Wave 1: 低リスク移行 (Month 3-4)
├── メールサーバー → Microsoft 365
│   └── ハイブリッド移行（段階的メールボックス移行）
├── ファイルサーバー → Azure Files
│   └── Azure File Sync でオンライン同期開始
└── Gate: メール/ファイル移行完了, ユーザー満足度確認

Wave 2: 社内ポータル (Month 5-7)
├── .NET Framework → .NET 8 リファクタリング
├── SQL Server 2016 → Azure SQL Database (DMS)
├── App Service へのデプロイ
├── 並行稼働テスト（2週間）
├── DNS 切り替え（土曜夜間メンテナンス）
└── Gate: 機能テスト OK, パフォーマンステスト OK

Wave 3: 生産管理 (Month 8-10)
├── Phase A: Azure VM へのリフト&シフト
│   ├── Azure Site Recovery でレプリケーション
│   ├── ExpressRoute 開通
│   └── オンプレ設備との連携テスト
├── Phase B: 切り替え（計画ダウンタイム 4時間）
│   ├── 最終データ同期
│   ├── DNS 切り替え
│   └── 疎通確認
└── Gate: 24時間監視, ロールバック準備

Wave 4: 最適化 & 完了 (Month 11-12)
├── 生産管理の PaaS 化検討
├── コスト最適化（Reserved Instance 適用）
├── 監視・アラート最適化
├── DR テスト実施
├── オンプレ環境の縮小計画
└── Gate: 全システム安定稼働確認
```
