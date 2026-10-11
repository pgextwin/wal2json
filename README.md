# wal2json — Windows x64 binaries (pgextwin)

[日本語](README_ja.md) | English

This repository publishes unofficial Windows x64 binaries of the [wal2json](https://github.com/eulerto/wal2json) **2.6** logical-decoding output plugin, pinned to upstream commit `75629c2e1e81a12350cc9d63782fc53252185d8d`.

**Current published release:** [v2.6-windows.1](https://github.com/pgextwin/wal2json/releases/tag/v2.6-windows.1), for PostgreSQL **14–18**. Use the ZIP matching your PostgreSQL major. Check SHA256, SPDX SBOM, Grype and attestations in the [pgextwin Catalog](https://pgextwin.github.io/website/en/). This is not an upstream-official Windows release.

Unlike SQL extensions, this output plugin uses **no `CREATE EXTENSION`**. It is loaded through a logical replication slot; no shared preload is required. The Windows CI verifies PostgreSQL startup, slot creation, committed INSERT/UPDATE/DELETE decoding into JSON, assertion of all three change kinds, and slot cleanup. Server-log assertions and SQL extension upgrades do not apply or are not covered.

For PostgreSQL versions containing the CVE-2026-6471 mitigations (including PG18.6), `output_plugin_libraries` must explicitly permit `wal2json`. Enable `wal_level = logical` and allocate sufficient replication slots before use. Review [PostgreSQL replication configuration](https://www.postgresql.org/docs/18/runtime-config-replication.html) and [Windows guidance](docs/windows.md).

PostgreSQL 14 is eligible for new builds until **2026-11-12** (EOL); previously published assets remain available as historical downloads. Review compatibility and permissions before deploying a logical decoding plugin in production.
