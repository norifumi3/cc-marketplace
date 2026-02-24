# cc-marketplace

個人用 Claude Code プラグインマーケットプレイス

## インストール

```bash
/plugin marketplace add norifumi3/cc-marketplace
```

## 含まれるプラグイン

### agent-memory
永続的なメモリ管理スキル。会話を超えて情報を保存・参照できます。

```bash
/plugin install agent-memory@cc-marketplace
```

### ms-docs-researcher
Microsoft公式ドキュメントの検索・取得スキル。Azure、Power Platform、Microsoft 365などのドキュメントを効率的に調査できます。

```bash
/plugin install ms-docs-researcher@cc-marketplace
```

### azure-architect-agents
Azure アーキテクチャ設計・実装支援システム。5つのスキル(S1-S5)と12のサブエージェント(A1-A12)による多層構造で、設計レビューから移行計画まで包括的にサポートします。

```bash
/plugin install azure-architect-agents@cc-marketplace
```

**含まれるスキル:**
- **S1. Architecture Design Review**: WAF 5柱 + リファレンス比較による設計レビュー
- **S2. CAF Journey Guide**: CAF成熟度評価とロードマップ
- **S3. Landing Zone Blueprint**: ALZ 8設計領域の包括的設計書生成
- **S4. New Workload Design**: 新規ワークロードのゼロからの設計
- **S5. Migration Planning**: オンプレ/他クラウドからの移行計画策定

## 使い方

プラグインをインストール後、各スキルは自動的に有効になります。

- **agent-memory**: 「これを記憶して」「前回の決定事項を教えて」などと指示
- **ms-docs-researcher**: Microsoft製品について質問すると自動的にドキュメントを検索
- **azure-architect-agents**: 「この設計をレビューして」「ランディングゾーンを設計して」「移行計画を立てて」などと指示
