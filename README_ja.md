# wal2json — Windows x64 バイナリ（pgextwin）

[English](README.md) | 日本語

上流[wal2json](https://github.com/eulerto/wal2json) **2.6**（固定コミット `75629c2e1e81a12350cc9d63782fc53252185d8d`）を基にした、論理デコード出力プラグインの非公式Windows x64バイナリです。

**現在の公開Release：** [v2.6-windows.1](https://github.com/pgextwin/wal2json/releases/tag/v2.6-windows.1)。PostgreSQL **14〜18**向けZIPを正式公開しています。PGメジャーを一致させ、SHA256・SPDX SBOM・Grype・証明情報を[pgextwin Pages](https://pgextwin.github.io/website/ja/)で確認してください。上流公式によるWindows配布ではありません。

wal2jsonはSQL拡張機能ではないため、**`CREATE EXTENSION`は不要**です。論理レプリケーションスロットから利用し、通常の`shared_preload_libraries`も不要です。Windows CIではPostgreSQL起動、スロット作成、INSERT・UPDATE・DELETEのコミット、3種類のJSONデコード検証、スロット削除までを確認しています。

CVE-2026-6471対策を含むPostgreSQL（PG18.6など）では、`output_plugin_libraries`に`wal2json`を明示的に許可する必要があります。`wal_level = logical`、レプリケーションスロット数、実行権限も確認してください。[PostgreSQL公式の論理レプリケーション設定](https://www.postgresql.org/docs/18/runtime-config-replication.html)と[Windows導入ガイド](docs/windows_ja.md)を参照してください。

PostgreSQL 14の新規ビルドは公式EOLの**2026-11-12**までとし、公開済みZIPはEOL後も履歴として残します。実運用前に対象環境での互換性とセキュリティを検証してください。
