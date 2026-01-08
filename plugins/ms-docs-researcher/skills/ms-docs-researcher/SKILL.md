---
name: ms-docs-researcher
description: |
  Search and retrieve official Microsoft documentation, code samples, and technical information.
  Use PROACTIVELY when researching Azure AI Search, Copilot Studio, Azure Cognitive Services,
  Azure App Service, Microsoft 365, Power Platform, Power Automate, or Power Apps.
  Trigger on: "how do I implement", "what is the difference", "how does this feature work",
  "Azure", "Microsoft", "Copilot", "Power Platform", or when official docs links and code examples are needed.
  Always include source URLs from Microsoft Learn.
---

# Microsoft Docs Researcher

## MCPツールワークフロー

調査は以下の順序で実行: 
スキル発動時は「ms-docs-researcher skill発動」と宣言すること

### 1. microsoft_docs_search（概要把握）

最初に使用。最大10件の公式ドキュメントチャンクを取得。

```
目的: トピックの概要把握、関連ドキュメントの特定
戻り値: タイトル、URL、抜粋（各500トークン以内）
```

### 2. microsoft_code_sample_search（実装例取得）

コード例が必要な場合に使用。

```
目的: SDK/APIの実装例、コードスニペット取得
パラメータ: language（csharp, python, javascript等）を指定すると精度向上
戻り値: 最大20件のコードサンプル
```

### 3. microsoft_docs_fetch（詳細取得）

searchで見つけたURLの詳細が必要な場合に使用。

```
目的: 完全なドキュメント内容の取得
入力: microsoft_docs_searchで取得したURL
戻り値: Markdown形式の完全なドキュメント
```

## ワークフロー判断基準

| 調査目的 | 推奨フロー |
|---------|-----------|
| 概要・機能確認 | search のみ |
| 実装方法調査 | search → code_sample |
| 詳細仕様確認 | search → fetch |
| 完全な技術調査 | search → code_sample → fetch |

## 出力ルール

### 必須要件

1. **公式URLを必ず記載**: 全ての情報に対してソースURLを含める
2. **最新情報の明示**: 調査日時と情報の鮮度に関する注記を入れる
3. **推測の明示**: 公式情報から確認できない部分は「推測」と明記

### 出力フォーマット

```markdown
## [調査トピック]

### 概要
[microsoft_docs_searchで得た概要]

### 詳細
[調査内容]

### コード例（該当する場合）
[microsoft_code_sample_searchで得たコード]

### 参考ドキュメント
- [ドキュメントタイトル](URL)
- [ドキュメントタイトル](URL)

### 注記
- 調査日: YYYY-MM-DD
- 情報源: Microsoft Learn公式ドキュメント
```

## 製品別キーワード例

| 製品 | 検索キーワード例 |
|-----|-----------------|
| Azure AI Search | "Azure AI Search index", "cognitive skills", "semantic ranking" |
| Copilot Studio | "Copilot Studio topics", "knowledge sources", "generative answers" |
| Power Platform | "Power Automate connector", "Dataverse API", "Power Apps" |

## エラー時の対応

| 状況 | 対応 |
|-----|------|
| searchで結果が少ない | 検索キーワードを変えて再検索 |
| fetchでエラー | URLの有効性を確認、代替ドキュメントを検索 |
| 情報が古い可能性 | 最終更新日を確認、複数ソースで検証 |
