# 使用例: Web アプリ設計レビュー (S1)

## シナリオ
EC サイトのアーキテクチャ設計レビューを実施する。

## ユーザー入力例

```
以下のアーキテクチャをレビューしてください。

## システム概要
- ECサイト（B2C）
- 月間 100万 PV、ピーク時 500 req/s
- SLA 目標: 99.95%

## 現在のアーキテクチャ
- Azure App Service (Standard S2) × 1 インスタンス
- Azure SQL Database (S3)
- Azure Blob Storage（商品画像）
- Application Gateway（WAF v2）
- パブリック IP でインターネット公開

## 認証
- Azure AD B2C（顧客認証）
- App Service 内で JWT 検証

## データ
- SQL Database にすべてのデータを格納
- 商品画像は Blob Storage
- セッション情報はインメモリ
- バックアップは SQL の自動バックアップのみ

## 既知の課題
- ピーク時にレスポンスが遅くなる
- 月に1-2回、短時間のダウンタイムが発生
```

## 期待される実行フロー

### Step 1: 入力解析
- ワークロード種別: Web アプリケーション（EC サイト）
- SLA: 99.95%
- トラフィック: 500 req/s ピーク

### Step 2: A3 (Reference Architecture Matcher) 起動
**入力**: EC サイト、99.95% SLA、500 req/s
**期待される出力**:
- 推奨リファレンス: Reliable Web App Pattern + Scalable Web App
- ギャップ: キャッシュなし、CDN なし、マルチインスタンスなし

### Step 3: A1 (WAF Pillar Analyst) × 5 並列起動
各柱で期待される検出事項:

#### Reliability
- ❌ RE:04 冗長性: App Service が 1 インスタンスのみ（SPOF）
- ❌ RE:05 マルチリージョン: 単一リージョン
- ⚠️ RE:07 ヘルスモデリング: ヘルスチェック未実装
- ❌ RE:08 自己修復: スケーリングルールなし
- ⚠️ RE:10 バックアップ: SQL のみ、Blob はバックアップなし

#### Security
- ❌ SE:04 セグメンテーション: パブリック IP で直接公開
- ⚠️ SE:05 ID管理: JWT 検証は OK だが、Managed Identity 未使用
- ⚠️ SE:06 暗号化: TDE はデフォルトだが CMK 未使用
- ❌ SE:07 ネットワーク: Private Endpoint 未使用

#### Cost Optimization
- ⚠️ CO:03 SKU: S2 が適切か検証必要
- ❌ CO:06 価格モデル: Reserved Instance 未使用
- ⚠️ CO:12 スケーリング: 固定インスタンスでコスト非効率

#### Operational Excellence
- ❌ OE:05 IaC: IaC の記述なし（手動デプロイの可能性）
- ❌ OE:07 監視: 監視設計の記載なし
- ⚠️ OE:04 安全なデプロイ: デプロイ戦略の記載なし

#### Performance Efficiency
- ❌ PE:09 キャッシング: キャッシュ層なし（Redis 未使用）
- ❌ PE:05 スケーリング: スケーリングルールなし
- ⚠️ PE:10 ネットワーク: CDN なし（画像配信の非効率）
- ❌ セッション管理: インメモリセッションはスケーリング不可

### Step 4: 条件付き深掘り
- Reliability に Critical 問題 → A9 (DR/HA Planner) 起動
- Performance に Critical 問題 → A5 (Network Architect) 起動

### Step 5: 統合レポート

## 期待される出力（Top 5 改善アクション）

1. **[Critical][Reliability]** App Service を複数インスタンス（最低 2）に変更し、可用性ゾーンを有効化
2. **[Critical][Security]** Private Endpoint を導入し、パブリックアクセスを無効化
3. **[Critical][Performance]** Azure Cache for Redis を追加し、セッション管理とデータキャッシュを実装
4. **[High][Performance]** Azure CDN / Front Door を導入し、静的コンテンツを配信
5. **[High][Reliability]** 自動スケーリングルールを設定（CPU 70% / メモリ 80% でスケールアウト）
