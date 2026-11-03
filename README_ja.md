# wal2json — Windows x64 バイナリ

[English](README.md) | 日本語

[wal2json](https://github.com/eulerto/wal2json)の**非公式Windows x64バイナリ**を配布しています。WALの論理デコード結果をJSONとして出力するプラグインです。

## ダウンロードと対応環境

[最新の公開Release](https://github.com/pgextwin/wal2json/releases/latest)からダウンロードできます。[過去のReleases](https://github.com/pgextwin/wal2json/releases)も確認できます。PostgreSQL **14〜18**向けの公開状況は[pgextwinカタログ](https://pgextwin.github.io/website/ja/)に掲載しています。

**利用中のPostgreSQLメジャーバージョンに一致するZIP**を選んでください。異なるメジャー向けのファイルは混在させないでください。PostgreSQL 14は2026年11月12日にコミュニティサポートが終了します。過去の配布ファイルはその後も残る場合があります。

## インストール

1. 事前にバックアップを取り、[上流ドキュメント](https://github.com/eulerto/wal2json)で必要な環境を確認します。
2. 既存ファイルの入れ替え前にPostgreSQLを停止し、対応するZIPを展開します。
3. ZIPに含まれるファイルを、上流の説明に従ってPostgreSQLの該当ディレクトリへ配置してください。
4.  wal2jsonは通常のSQL拡張機能とは異なり、CREATE EXTENSIONは不要です。論理レプリケーション用の設定・利用手順は上流ドキュメントを確認してください。 サーバー設定を変更した場合はPostgreSQLを再起動します。

ダウンロードしたZIPはReleaseのSHA256SUMS.txtで照合できます。ReleaseによってはSPDX形式のSBOM、脆弱性レポート、署名付き証明も提供されています。本番環境の前に検証環境で動作を確認してください。

## 上流プロジェクトとライセンス

使い方、設定、制限事項は[上流のwal2json](https://github.com/eulerto/wal2json)を参照してください。本配布は上流の公式Windows版ではありません。再配布条件は同梱のライセンス表記に従います。
