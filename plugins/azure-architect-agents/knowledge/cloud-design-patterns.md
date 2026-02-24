# クラウドデザインパターン

## 概要
Azure Architecture Center で定義されている 37+ のクラウドデザインパターン。WAF の各柱に対応。

---

## カテゴリ別パターン一覧

### 可用性 (Availability)

| パターン | 概要 | 適用例 |
|---------|------|--------|
| **Deployment Stamps** | 独立したインフラスタンプを複数デプロイ | マルチリージョン、テナント分離 |
| **Geode** | 地理的に分散したバックエンドサービス | グローバルサービス |
| **Health Endpoint Monitoring** | ヘルスチェックエンドポイントを実装 | LB ヘルスプローブ、監視 |
| **Queue-Based Load Leveling** | キューでバーストトラフィックを平滑化 | 非同期処理、バックエンド保護 |
| **Throttling** | リソースの消費制限 | API レート制限 |
| **Bulkhead** | 障害を分離区画に閉じ込める | マイクロサービスの障害分離 |
| **Circuit Breaker** | 障害の連鎖を防止 | 外部サービス呼び出し |

### 回復性 (Resiliency)

| パターン | 概要 | 適用例 |
|---------|------|--------|
| **Retry** | 一時的な障害のリトライ | API 呼び出し、DB 接続 |
| **Compensating Transaction** | 部分的に完了した操作の取り消し | 分散トランザクション |
| **Scheduler Agent Supervisor** | 分散アクションの調整と復旧 | 長時間実行ワークフロー |

### データ管理 (Data Management)

| パターン | 概要 | 適用例 |
|---------|------|--------|
| **Cache-Aside** | データストアからキャッシュへのオンデマンドロード | Redis + SQL DB |
| **CQRS** | 読み取りと書き込みの分離 | 高スケール読み取り |
| **Event Sourcing** | 状態変更をイベントとして記録 | 監査ログ、ドメインイベント |
| **Index Table** | 参照頻度の高いフィールドにインデックス作成 | NoSQL データストア |
| **Materialized View** | 事前計算されたビューの生成 | レポーティング |
| **Sharding** | データの水平パーティショニング | 大規模 DB |
| **Static Content Hosting** | 静的コンテンツの CDN 配信 | SPA、画像、JS/CSS |
| **Valet Key** | 一時的な直接アクセストークン | Blob Storage の SAS |
| **Claim Check** | 大きなメッセージの参照渡し | メッセージキュー |

### メッセージング (Messaging)

| パターン | 概要 | 適用例 |
|---------|------|--------|
| **Competing Consumers** | 複数のコンシューマーによる並列処理 | キュー処理のスケールアウト |
| **Priority Queue** | 優先度付きメッセージ処理 | 重要度別の処理 |
| **Publisher-Subscriber** | イベントの発行と購読 | Event Grid、Service Bus Topic |
| **Asynchronous Request-Reply** | 非同期リクエストと結果取得 | 長時間処理 |
| **Choreography** | 中央オーケストレーターなしの分散連携 | マイクロサービス |
| **Saga** | 分散トランザクションの管理 | マイクロサービスの整合性 |
| **Sequential Convoy** | 関連メッセージの順序保証処理 | セッション処理 |

### セキュリティ (Security)

| パターン | 概要 | 適用例 |
|---------|------|--------|
| **Federated Identity** | 外部 ID プロバイダーへの認証委任 | Entra ID、B2C |
| **Gatekeeper** | 専用ホストでリクエストを検証 | API Gateway、WAF |
| **Ambassador** | サービスの前にプロキシを配置 | サイドカーTLS |

### 設計と実装 (Design & Implementation)

| パターン | 概要 | 適用例 |
|---------|------|--------|
| **Ambassador** | ヘルパーサービスでネットワーク関連処理を代行 | ロギング、ルーティング |
| **Anti-Corruption Layer** | レガシーシステムとの境界を保護 | 移行、統合 |
| **Backends for Frontends (BFF)** | フロントエンド別のバックエンド | モバイル/Web 分離 |
| **External Configuration Store** | 外部設定ストアの利用 | App Configuration |
| **Gateway Aggregation** | ゲートウェイでの複数リクエスト集約 | APIM |
| **Gateway Offloading** | 共有機能のゲートウェイへの集約 | TLS 終端、認証 |
| **Gateway Routing** | ゲートウェイでのルーティング | URL ベースルーティング |
| **Sidecar** | アプリに付随するヘルパーコンテナ | ロギング、監視 |
| **Strangler Fig** | レガシーシステムの段階的置換 | モダナイゼーション |

### パフォーマンス (Performance)

| パターン | 概要 | 適用例 |
|---------|------|--------|
| **Pipes and Filters** | パイプライン処理のステージ分解 | データ処理パイプライン |
| **Compute Resource Consolidation** | 計算リソースの統合 | コンテナ化 |

---

## WAF 柱とパターンの対応マトリクス

| パターン | Rel | Sec | Cost | OpEx | Perf |
|---------|:---:|:---:|:----:|:----:|:----:|
| Circuit Breaker | ● | | | | |
| Retry | ● | | | | |
| Bulkhead | ● | | | | |
| Health Endpoint Mon. | ● | | | ● | |
| Queue-Based Load Lev. | ● | | ● | | ● |
| Deployment Stamps | ● | | | | ● |
| Geode | ● | | | | ● |
| Throttling | ● | ● | ● | | |
| Cache-Aside | | | ● | | ● |
| CQRS | | | | | ● |
| Sharding | | | | | ● |
| Gatekeeper | | ● | | | |
| Valet Key | | ● | | | |
| Federated Identity | | ● | | | |
| Anti-Corruption Layer | | | | ● | |
| Strangler Fig | | | | ● | |
| Sidecar | | | | ● | |
| External Config Store | | | | ● | |
| Static Content Hosting | | | ● | | ● |
| Competing Consumers | | | | | ● |
| Priority Queue | | | | | ● |

Rel=Reliability, Sec=Security, Cost=Cost Optimization, OpEx=Operational Excellence, Perf=Performance Efficiency

---

## アンチパターン（避けるべきパターン）

| アンチパターン | 問題 | 対策 |
|-------------|------|------|
| **Noisy Neighbor** | 共有リソースの過剰消費 | Bulkhead、リソース分離 |
| **Retry Storm** | リトライの連鎖によるシステム過負荷 | Circuit Breaker、Exponential Backoff |
| **Single Point of Failure** | 冗長性なしの単一障害点 | 冗長構成、AZ 活用 |
| **Chatty I/O** | 細かい呼び出しの多発 | バッチ処理、Gateway Aggregation |
| **Improper Instantiation** | 高コストオブジェクトの頻繁な生成 | シングルトン、接続プーリング |
| **No Caching** | キャッシュなしの反復的データ取得 | Cache-Aside |
| **Synchronous I/O** | 同期呼び出しによるブロッキング | 非同期パターン |
| **Busy Frontend** | フロントエンドでの重い処理 | BFF、バックエンド処理 |
