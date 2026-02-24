# 技術選択ガイド (Technology Choice Guides)

## 概要
Azure Architecture Center の技術選択決定木を整理。主要なコンポーネント選択の判断基準を提供。

---

## 1. Compute（コンピュートサービス選択）

### 決定木

```
ワークロードの種類は？
├── VM ベース（IaaS 移行、カスタム OS）
│   └── → Azure Virtual Machines
│       └── スケールが必要？ → VM Scale Sets
│
├── コンテナベース
│   ├── Kubernetes が必要？
│   │   ├── Yes → Azure Kubernetes Service (AKS)
│   │   └── No → コンテナの複雑さは？
│   │       ├── シンプル → Azure Container Apps
│   │       └── バッチ処理 → Azure Container Instances
│   └── Dapr/KEDA が重要？ → Azure Container Apps
│
├── Web アプリ
│   ├── フルマネージドが必要？ → Azure App Service
│   └── 静的サイト？ → Azure Static Web Apps
│
├── サーバーレス / イベント駆動
│   └── → Azure Functions
│
└── バッチ / HPC
    └── → Azure Batch
```

### 比較マトリクス

| 基準 | VM | App Service | AKS | Container Apps | Functions |
|------|-----|------------|-----|---------------|-----------|
| **制御レベル** | 最高 | 低 | 高 | 中 | 最低 |
| **運用負荷** | 高 | 低 | 中-高 | 低 | 最低 |
| **スケーリング** | 手動/VMSS | 自動 | HPA/KEDA | KEDA | 自動 |
| **コスト効率** | 中 | 中 | 中-高 | 高 | 最高（低負荷） |
| **起動時間** | 分 | 秒 | 秒 | 秒 | ミリ秒 |
| **最小料金** | VM 時間 | Plan 時間 | ノード時間 | 従量 or 専用 | 従量 or 専用 |
| **マルチコンテナ** | — | Limited | Full | Full | Limited |
| **GPU** | ○ | — | ○ | — | — |

---

## 2. Database（データストア選択）

### 決定木

```
データの性質は？
├── リレーショナル
│   ├── SQL Server 互換が必要？
│   │   ├── フルマネージド → Azure SQL Database
│   │   ├── インスタンスレベル互換 → SQL Managed Instance
│   │   └── 完全制御 → SQL Server on VM
│   ├── PostgreSQL 互換？ → Azure Database for PostgreSQL Flexible
│   └── MySQL 互換？ → Azure Database for MySQL Flexible
│
├── NoSQL / ドキュメント
│   ├── グローバル分散が必要？ → Azure Cosmos DB
│   ├── JSON ドキュメント？ → Cosmos DB (NoSQL API)
│   └── MongoDB 互換？ → Cosmos DB (MongoDB API) or MongoDB vCore
│
├── キー・バリュー / キャッシュ
│   └── → Azure Cache for Redis
│
├── 列ファミリー / ワイドカラム
│   └── → Cosmos DB (Table API) or Apache Cassandra MI
│
├── グラフ
│   └── → Cosmos DB (Gremlin API)
│
├── 時系列
│   └── → Azure Data Explorer
│
└── 全文検索
    └── → Azure AI Search
```

### 比較マトリクス

| 基準 | SQL DB | Cosmos DB | PostgreSQL | Redis |
|------|--------|-----------|------------|-------|
| **モデル** | リレーショナル | マルチモデル | リレーショナル | KV/Cache |
| **一貫性** | Strong | 5 レベル | Strong | Eventual |
| **スケーリング** | Vertical + Read | Horizontal | Vertical | Vertical |
| **グローバル分散** | Geo Replication | ネイティブ | — | Geo Rep |
| **サーバーレス** | ○ | ○ | — | — |
| **最低コスト** | 〜$5/月 | 〜$25/月 | 〜$13/月 | 〜$16/月 |

---

## 3. Messaging（メッセージングサービス選択）

### 決定木

```
メッセージングの目的は？
├── イベント通知（1:N、ファンアウト）
│   ├── リアクティブプログラミング → Azure Event Grid
│   └── 高スループットストリーミング → Azure Event Hubs
│
├── コマンド / リクエスト（1:1）
│   ├── エンタープライズ機能（トランザクション、順序保証）
│   │   └── → Azure Service Bus
│   └── シンプルなキュー
│       └── → Azure Storage Queue
│
└── ワークフロー / オーケストレーション
    └── → Service Bus + Durable Functions
```

### 比較マトリクス

| 基準 | Service Bus | Event Hubs | Event Grid | Storage Queue |
|------|------------|-----------|-----------|--------------|
| **パターン** | Queue/Topic | Stream | Event | Queue |
| **順序保証** | FIFO (Session) | パーティション内 | — | — |
| **スループット** | 中 | 非常に高 | 高 | 中 |
| **保持期間** | 〜14日 | 〜90日 | 24時間 | 〜7日 |
| **Dead Letter** | ○ | — | ○ | ○ |
| **トランザクション** | ○ | — | — | — |
| **コスト** | 中 | 中-高 | 低 | 最低 |

---

## 4. Load Balancing（負荷分散サービス選択）

### 決定木

```
トラフィックの種類は？
├── HTTP/HTTPS
│   ├── グローバル（マルチリージョン）？
│   │   ├── CDN + WAF + SSL offload → Azure Front Door
│   │   └── DNS ベースのルーティングのみ → Traffic Manager
│   └── リージョン内
│       └── → Application Gateway (+ WAF v2)
│
└── Non-HTTP（TCP/UDP）
    ├── グローバル？
    │   └── → Traffic Manager
    └── リージョン内
        └── → Azure Load Balancer (Standard)
```

### 比較マトリクス

| 基準 | Front Door | App Gateway | Load Balancer | Traffic Manager |
|------|-----------|------------|--------------|----------------|
| **スコープ** | グローバル | リージョン | リージョン | グローバル |
| **プロトコル** | HTTP/S | HTTP/S | TCP/UDP | DNS |
| **WAF** | ○ | ○ | — | — |
| **SSL 終端** | ○ | ○ | — | — |
| **URL ルーティング** | ○ | ○ | — | — |
| **セッション親和性** | ○ | ○ | ○ | — |
| **ヘルスプローブ** | HTTP/S | HTTP/S/TCP | TCP/HTTP | HTTP/S/TCP |

---

## 5. AI サービス選択

### 決定木

```
AI の用途は？
├── 生成 AI（LLM）
│   ├── OpenAI モデル → Azure OpenAI Service
│   ├── オープンソースモデル → Azure AI Foundry (Model Catalog)
│   └── カスタムチャットアプリ → Azure AI Foundry + Prompt Flow
│
├── RAG（検索拡張生成）
│   └── → Azure AI Search + Azure OpenAI
│
├── ドキュメント処理
│   └── → Azure AI Document Intelligence
│
├── 音声
│   ├── 音声認識 → Azure AI Speech (STT)
│   └── 音声合成 → Azure AI Speech (TTS)
│
├── 画像/ビジョン
│   └── → Azure AI Vision
│
├── カスタム ML モデル
│   ├── コードファースト → Azure Machine Learning
│   └── AutoML → Azure Machine Learning (AutoML)
│
└── AI エージェント
    └── → Azure AI Foundry + Agent Service
```

---

## 6. Storage（ストレージ選択）

| データ種別 | 推奨サービス | 備考 |
|-----------|------------|------|
| 非構造化ファイル | Blob Storage | Hot/Cool/Archive 層 |
| ファイル共有（SMB/NFS） | Azure Files | Premium/Standard |
| 高性能ファイルストレージ | Azure NetApp Files | NFS/SMB |
| ディスク | Managed Disks | Premium SSD v2/Ultra |
| テーブルデータ | Table Storage or Cosmos DB | 規模による |
| キューメッセージ | Queue Storage | シンプルキュー |
| Data Lake | ADLS Gen2 (Blob + HNS) | 分析用 |

---

## 7. CI/CD パイプライン選択

| 基準 | GitHub Actions | Azure DevOps | GitLab CI |
|------|---------------|-------------|-----------|
| **Git ホスティング** | GitHub | Azure Repos/GitHub | GitLab |
| **YAML パイプライン** | ○ | ○ | ○ |
| **マーケットプレイス** | 大規模 | 中規模 | 中規模 |
| **セルフホストランナー** | ○ | ○ | ○ |
| **Azure 統合** | 良好 | 最良 | 良好 |
| **コスト** | 無料枠あり | 無料枠あり | 無料枠あり |
