# Azure リファレンスアーキテクチャカタログ

## 概要
Azure Architecture Center から主要なリファレンスアーキテクチャを分類・整理したカタログ。

---

## Web アプリケーション

### Enterprise Web App Patterns（進行パターン）

| レベル | パターン | 概要 |
|-------|---------|------|
| **Converging** | Reliable Web App Pattern | オンプレ Web アプリのクラウド移行（信頼性重視） |
| **Expanding** | Modern Web App Pattern | モダン化による機能拡張 |
| **Optimizing** | (将来) | クラウドネイティブ最適化 |

### 個別リファレンス
| 名称 | コンポーネント | SLA 目標 |
|------|-------------|---------|
| Basic Web App | App Service + SQL DB | 99.9% |
| Scalable Web App | App Service + SQL DB + Redis + CDN | 99.95% |
| Multi-region Web App | Front Door + App Service x2 + SQL Geo | 99.99% |
| Serverless Web App | Static Web Apps + Functions + Cosmos DB | 99.9% |
| Web App with Private Endpoint | App Service + Private Endpoint + App GW | 99.9% |

---

## コンテナ / マイクロサービス

### AKS (Azure Kubernetes Service)
| 名称 | 概要 | SLA |
|------|------|-----|
| **AKS Baseline** | AKS 推奨構成のベースライン | 99.95% |
| AKS Baseline for Multiregion | マルチリージョン AKS | 99.99% |
| AKS with Azure Service Mesh | Istio 統合 | 99.95% |
| Microservices on AKS | マイクロサービスアーキテクチャ | 99.95% |
| AKS for PCI-DSS | PCI DSS 準拠 AKS | 99.95% |
| AKS Private Cluster | プライベートクラスター | 99.95% |
| AKS Day-2 Operations | 運用ガイド | — |

### Container Apps
| 名称 | 概要 | SLA |
|------|------|-----|
| **Container Apps Baseline** | Container Apps 基本構成 | 99.95% |
| Container Apps with APIM | API 管理統合 | 99.95% |
| Container Apps Landing Zone Accelerator | LZA 統合 | 99.95% |

---

## データプラットフォーム

| 名称 | 主要サービス | 用途 |
|------|------------|------|
| Modern Data Analytics | Synapse + Data Factory + Purview | EDW + ETL |
| Real-time Analytics | Event Hubs + Azure Data Explorer | ストリーミング分析 |
| Data Lakehouse | Databricks + Delta Lake | 統合分析基盤 |
| Stream Processing | Event Hubs + Stream Analytics | イベント処理 |
| IoT Analytics | IoT Hub + Stream Analytics + TSI | IoT データ分析 |
| Batch Processing | Data Factory + Databricks + ADLS | バッチ ETL |

---

## AI / ML

| 名称 | 主要サービス | 用途 |
|------|------------|------|
| **Foundry Chat Baseline** | AI Foundry + GPT-4o + AI Search | チャットアプリ |
| **RAG with AI Search** | AI Search + Foundry + Embedding | 検索拡張生成 |
| **Agent Orchestration** | Foundry + Tools + MCP | マルチエージェント |
| **GenAI Gateway** | APIM + Azure OpenAI | AI ゲートウェイ |
| MLOps v2 | ML Workspace + Pipelines | ML 運用 |
| Batch Scoring | ML Workspace + Batch Endpoint | バッチ推論 |
| Real-time Scoring | ML Workspace + Online Endpoint | リアルタイム推論 |

---

## ネットワーキング

| 名称 | 概要 |
|------|------|
| Hub-Spoke Topology | Azure Firewall Hub + Spoke VNets |
| Virtual WAN | マネージド WAN ハブ |
| DMZ between Azure and On-premises | NVA ベースの DMZ |
| Firewall and Application Gateway | 統合セキュリティ |
| Private Link Hub | 集中 Private Link 管理 |

---

## ハイブリッド

| 名称 | 概要 |
|------|------|
| Azure Arc Hybrid Management | ハイブリッド管理基盤 |
| Azure Stack HCI | ハイブリッドインフラ |
| Hybrid DNS | Azure-OnPrem DNS 統合 |
| Hybrid Identity | Entra ID + AD DS 統合 |

---

## セキュリティ

| 名称 | 概要 |
|------|------|
| Zero Trust Network | ゼロトラストネットワーク設計 |
| Microsoft Sentinel | SIEM/SOAR 基盤 |
| Defender for Cloud | クラウドセキュリティ統合 |
| Confidential Computing | 機密コンピューティング |

---

## サーバーレス

| 名称 | 主要サービス | 用途 |
|------|------------|------|
| Serverless Event Processing | Functions + Event Grid | イベント駆動 |
| Serverless API Backend | Functions + APIM + Cosmos DB | API バックエンド |
| Serverless Web App | Static Web Apps + Functions | SPA + API |

---

## ミッションクリティカル

| 名称 | Compute | SLA |
|------|---------|-----|
| **MC Baseline on AKS** | AKS | 99.99%+ |
| **MC Baseline on App Service** | App Service | 99.99%+ |
| **MC with ALZ Integration** | AKS/App Service | 99.99%+ |
| MC Connected | オンプレ接続統合 | 99.99%+ |

### Mission-Critical 共通設計原則
- マルチリージョン Active-Active
- スケールユニットベースのデプロイ
- ヘルスモデリングによる自動フェイルオーバー
- Chaos Engineering によるテスト
- ゼロダウンタイムデプロイ

---

## アーキテクチャスタイル選択ガイド

| 要件 | 推奨スタイル |
|------|------------|
| シンプルな CRUD アプリ | N-tier |
| バックグラウンド処理あり | Web-Queue-Worker |
| 複雑なドメイン、独立デプロイ | Microservices |
| イベント駆動、非同期処理 | Event-driven |
| 大量データの処理・分析 | Big Data |
| 計算集約型のバッチ処理 | Big Compute (HPC) |
| 読み書きの負荷が大きく異なる | CQRS |
