# wal2json — Windows x64

[日本語](README_ja.md) | English

This repository provides **unofficial Windows x64 packages** of [wal2json](https://github.com/eulerto/wal2json). wal2json emits logical decoding changes in JSON format.

## Downloads and compatibility

Download the [latest published Release](https://github.com/pgextwin/wal2json/releases/latest), or [view all Releases](https://github.com/pgextwin/wal2json/releases). Published packages for PostgreSQL **14–18** are listed in the [pgextwin catalog](https://pgextwin.github.io/website/en/).

Select the ZIP for **your PostgreSQL major version**. Do not mix files built for different majors. PostgreSQL 14 community support ends on November 12, 2026; historical downloads may remain available afterward.

## Installation

1. Back up your installation and check the [upstream documentation](https://github.com/eulerto/wal2json) for prerequisites.
2. Stop PostgreSQL before replacing installed files. Unpack the ZIP matching your PostgreSQL major.
3. Only copy the files actually included in the package.
4.  wal2json is an output plugin, not a SQL extension: CREATE EXTENSION is not required. Consult upstream instructions for logical decoding setup. Restart PostgreSQL if you changed server configuration.

Check the Release's SHA256SUMS.txt against the downloaded ZIP. Other available release materials can include SPDX SBOMs, vulnerability reports and signed attestations. Test in a non-production environment before deployment.

## Upstream and license

For usage, settings and limitations, refer to [wal2json upstream](https://github.com/eulerto/wal2json). This independent package is not an official upstream Windows distribution. The included license notices govern redistribution.
