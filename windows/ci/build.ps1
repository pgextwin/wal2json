[CmdletBinding()]
param([Parameter(Mandatory=$true)][string]$PgRoot,
      [Parameter(Mandatory=$true)][string]$UpstreamDir)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$config = Get-Content (Join-Path $PSScriptRoot '../../config/extension.json') -Raw | ConvertFrom-Json
$expected = [string]$config.upstream.commit
if ($expected -cnotmatch '^[a-f0-9]{40}$' -or $config.upstream.repository -cne 'eulerto/wal2json') { throw 'Invalid upstream identity' }
$actual = (& git -C $UpstreamDir rev-parse HEAD).Trim().ToLowerInvariant()
if ($LASTEXITCODE -ne 0 -or $actual -cne $expected) { throw "Upstream SHA mismatch: $actual" }
$pgVersion = (& (Join-Path $PgRoot 'bin/pg_config.exe') --version).Trim()
if ($LASTEXITCODE -ne 0 -or $pgVersion -notmatch '^PostgreSQL\s+(14|15|16|17|18)(?:\.|\s)') {
    throw "Unsupported PostgreSQL pilot target: $pgVersion"
}
$source = Join-Path $UpstreamDir 'wal2json.c'
if (-not (Test-Path $source -PathType Leaf)) { throw 'Missing source' }
$code = Get-Content $source -Raw

# Require an audited 2.x upstream version and keep tag, source and numeric
# version macros consistent with the immutable, SHA-pinned manifest.
$version = [string]$config.upstream.version
if ($version -cnotmatch '^2\.[0-9]{1,2}
$def = Join-Path $UpstreamDir 'pgextwin-exports.def'
[IO.File]::WriteAllLines($def,[string[]]@('LIBRARY wal2json','EXPORTS','    Pg_magic_func','    _PG_output_plugin_init'),[Text.Encoding]::ASCII)
$vswhere = Join-Path ([Environment]::GetFolderPath('ProgramFilesX86')) 'Microsoft Visual Studio/Installer/vswhere.exe'
if (-not (Test-Path $vswhere)) { throw 'vswhere missing' }
$vsroot = (& $vswhere -latest -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath | Select-Object -First 1)
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($vsroot)) { throw 'MSVC x64 toolchain missing' }
$vsdev = Join-Path $vsroot.Trim() 'Common7/Tools/VsDevCmd.bat'
$temp = if ($env:RUNNER_TEMP) { $env:RUNNER_TEMP } else { [IO.Path]::GetTempPath() }
$cmd = Join-Path $temp 'wal2json-msvc-build.cmd'
$obj = Join-Path $UpstreamDir 'wal2json.obj'
$dll = Join-Path $UpstreamDir 'wal2json.dll'
$lines = @(
    '@echo off',
    ('call "' + $vsdev + '" -arch=x64 -host_arch=x64'),
    'if errorlevel 1 exit /b %errorlevel%',
    ('cd /d "' + $UpstreamDir + '"'),
    ('cl /nologo /O2 /MD /DWIN32 /D__WINDOWS__ /DWIN32_NO_STATUS /D_CRT_SECURE_NO_WARNINGS /D_CRT_NONSTDC_NO_WARNINGS /I"{0}" /I"{1}" /I"{2}" /I"{3}" /c "{4}" /Fo"{5}"' -f
        (Join-Path $PgRoot 'include/server/port/win32_msvc'),(Join-Path $PgRoot 'include/server/port/win32'),
        (Join-Path $PgRoot 'include/server'),(Join-Path $PgRoot 'include'),$source,$obj),
    'if errorlevel 1 exit /b %errorlevel%',
    ('link /nologo /DLL /MACHINE:X64 /OUT:"{0}" /DEF:"{1}" "{2}" "{3}"' -f
        $dll,$def,$obj,(Join-Path $PgRoot 'lib/postgres.lib')),
    'if errorlevel 1 exit /b %errorlevel%',
    ('dumpbin /nologo /exports "' + $dll + '"'),
    'if errorlevel 1 exit /b %errorlevel%'
)
[IO.File]::WriteAllLines($cmd,[string[]]$lines,[Text.Encoding]::ASCII)
$output = @(& cmd.exe /d /c $cmd)
if ($LASTEXITCODE -ne 0 -or -not (Test-Path $dll)) {
    $output | ForEach-Object { Write-Host $_ }
    throw 'wal2json MSVC compile/link/dumpbin failed (do not waive)'
}
$dump = $output -join [Environment]::NewLine
foreach ($symbol in @('Pg_magic_func','_PG_output_plugin_init')) {
    if ($dump -notmatch ('(?m)\s' + [regex]::Escape($symbol) + '\s*$')) {
        throw "Required output plugin export missing: $symbol"
    }
}
Write-Host "Built pinned wal2json $version with output plugin entry point"
) {
    throw "Unsupported wal2json version $version; re-audit before compiling"
}
if ([string]$config.upstream.ref -cne ('wal2json_' + $version.Replace('.', '_'))) {
    throw 'Upstream tag does not match the pinned manifest version'
}
$expectedVersionNum = 200 + [int]($version.Split('.')[1])
$versionDefs = [regex]::Matches($code, '(?m)^[ \t]*#[ \t]*define[ \t]+WAL2JSON_VERSION[ \t]+"([^"\r\n]+)"[ \t]*\r?
$def = Join-Path $UpstreamDir 'pgextwin-exports.def'
[IO.File]::WriteAllLines($def,[string[]]@('LIBRARY wal2json','EXPORTS','    Pg_magic_func','    _PG_output_plugin_init'),[Text.Encoding]::ASCII)
$vswhere = Join-Path ([Environment]::GetFolderPath('ProgramFilesX86')) 'Microsoft Visual Studio/Installer/vswhere.exe'
if (-not (Test-Path $vswhere)) { throw 'vswhere missing' }
$vsroot = (& $vswhere -latest -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath | Select-Object -First 1)
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($vsroot)) { throw 'MSVC x64 toolchain missing' }
$vsdev = Join-Path $vsroot.Trim() 'Common7/Tools/VsDevCmd.bat'
$temp = if ($env:RUNNER_TEMP) { $env:RUNNER_TEMP } else { [IO.Path]::GetTempPath() }
$cmd = Join-Path $temp 'wal2json-msvc-build.cmd'
$obj = Join-Path $UpstreamDir 'wal2json.obj'
$dll = Join-Path $UpstreamDir 'wal2json.dll'
$lines = @(
    '@echo off',
    ('call "' + $vsdev + '" -arch=x64 -host_arch=x64'),
    'if errorlevel 1 exit /b %errorlevel%',
    ('cd /d "' + $UpstreamDir + '"'),
    ('cl /nologo /O2 /MD /DWIN32 /D__WINDOWS__ /DWIN32_NO_STATUS /D_CRT_SECURE_NO_WARNINGS /D_CRT_NONSTDC_NO_WARNINGS /I"{0}" /I"{1}" /I"{2}" /I"{3}" /c "{4}" /Fo"{5}"' -f
        (Join-Path $PgRoot 'include/server/port/win32_msvc'),(Join-Path $PgRoot 'include/server/port/win32'),
        (Join-Path $PgRoot 'include/server'),(Join-Path $PgRoot 'include'),$source,$obj),
    'if errorlevel 1 exit /b %errorlevel%',
    ('link /nologo /DLL /MACHINE:X64 /OUT:"{0}" /DEF:"{1}" "{2}" "{3}"' -f
        $dll,$def,$obj,(Join-Path $PgRoot 'lib/postgres.lib')),
    'if errorlevel 1 exit /b %errorlevel%',
    ('dumpbin /nologo /exports "' + $dll + '"'),
    'if errorlevel 1 exit /b %errorlevel%'
)
[IO.File]::WriteAllLines($cmd,[string[]]$lines,[Text.Encoding]::ASCII)
$output = @(& cmd.exe /d /c $cmd)
if ($LASTEXITCODE -ne 0 -or -not (Test-Path $dll)) {
    $output | ForEach-Object { Write-Host $_ }
    throw 'wal2json MSVC compile/link/dumpbin failed (do not waive)'
}
$dump = $output -join [Environment]::NewLine
foreach ($symbol in @('Pg_magic_func','_PG_output_plugin_init')) {
    if ($dump -notmatch ('(?m)\s' + [regex]::Escape($symbol) + '\s*$')) {
        throw "Required output plugin export missing: $symbol"
    }
}
Write-Host "Built pinned wal2json 2.6 with output plugin entry point"
)
$numberDefs = [regex]::Matches($code, '(?m)^[ \t]*#[ \t]*define[ \t]+WAL2JSON_VERSION_NUM[ \t]+([0-9]+)[ \t]*\r?
$def = Join-Path $UpstreamDir 'pgextwin-exports.def'
[IO.File]::WriteAllLines($def,[string[]]@('LIBRARY wal2json','EXPORTS','    Pg_magic_func','    _PG_output_plugin_init'),[Text.Encoding]::ASCII)
$vswhere = Join-Path ([Environment]::GetFolderPath('ProgramFilesX86')) 'Microsoft Visual Studio/Installer/vswhere.exe'
if (-not (Test-Path $vswhere)) { throw 'vswhere missing' }
$vsroot = (& $vswhere -latest -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath | Select-Object -First 1)
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($vsroot)) { throw 'MSVC x64 toolchain missing' }
$vsdev = Join-Path $vsroot.Trim() 'Common7/Tools/VsDevCmd.bat'
$temp = if ($env:RUNNER_TEMP) { $env:RUNNER_TEMP } else { [IO.Path]::GetTempPath() }
$cmd = Join-Path $temp 'wal2json-msvc-build.cmd'
$obj = Join-Path $UpstreamDir 'wal2json.obj'
$dll = Join-Path $UpstreamDir 'wal2json.dll'
$lines = @(
    '@echo off',
    ('call "' + $vsdev + '" -arch=x64 -host_arch=x64'),
    'if errorlevel 1 exit /b %errorlevel%',
    ('cd /d "' + $UpstreamDir + '"'),
    ('cl /nologo /O2 /MD /DWIN32 /D__WINDOWS__ /DWIN32_NO_STATUS /D_CRT_SECURE_NO_WARNINGS /D_CRT_NONSTDC_NO_WARNINGS /I"{0}" /I"{1}" /I"{2}" /I"{3}" /c "{4}" /Fo"{5}"' -f
        (Join-Path $PgRoot 'include/server/port/win32_msvc'),(Join-Path $PgRoot 'include/server/port/win32'),
        (Join-Path $PgRoot 'include/server'),(Join-Path $PgRoot 'include'),$source,$obj),
    'if errorlevel 1 exit /b %errorlevel%',
    ('link /nologo /DLL /MACHINE:X64 /OUT:"{0}" /DEF:"{1}" "{2}" "{3}"' -f
        $dll,$def,$obj,(Join-Path $PgRoot 'lib/postgres.lib')),
    'if errorlevel 1 exit /b %errorlevel%',
    ('dumpbin /nologo /exports "' + $dll + '"'),
    'if errorlevel 1 exit /b %errorlevel%'
)
[IO.File]::WriteAllLines($cmd,[string[]]$lines,[Text.Encoding]::ASCII)
$output = @(& cmd.exe /d /c $cmd)
if ($LASTEXITCODE -ne 0 -or -not (Test-Path $dll)) {
    $output | ForEach-Object { Write-Host $_ }
    throw 'wal2json MSVC compile/link/dumpbin failed (do not waive)'
}
$dump = $output -join [Environment]::NewLine
foreach ($symbol in @('Pg_magic_func','_PG_output_plugin_init')) {
    if ($dump -notmatch ('(?m)\s' + [regex]::Escape($symbol) + '\s*$')) {
        throw "Required output plugin export missing: $symbol"
    }
}
Write-Host "Built pinned wal2json 2.6 with output plugin entry point"
)
if ($versionDefs.Count -ne 1 -or $numberDefs.Count -ne 1 -or
    $versionDefs[0].Groups[1].Value -cne $version -or
    [int]$numberDefs[0].Groups[1].Value -ne $expectedVersionNum) {
    throw "Upstream WAL2JSON_VERSION and WAL2JSON_VERSION_NUM must match pinned version $version"
}
if ($code -notmatch '\bPG_MODULE_MAGIC(?:_EXT)?\b' -or
    $code -notmatch '\bPGDLLEXPORT\s+_PG_output_plugin_init\s*\(' -or
    $code -notmatch '(?m)^\s*_PG_output_plugin_init\s*\(OutputPluginCallbacks\s*\*\s*cb\s*\)') {
    throw 'Upstream plugin API or exports changed; re-audit before compiling'
}
$def = Join-Path $UpstreamDir 'pgextwin-exports.def'
[IO.File]::WriteAllLines($def,[string[]]@('LIBRARY wal2json','EXPORTS','    Pg_magic_func','    _PG_output_plugin_init'),[Text.Encoding]::ASCII)
$vswhere = Join-Path ([Environment]::GetFolderPath('ProgramFilesX86')) 'Microsoft Visual Studio/Installer/vswhere.exe'
if (-not (Test-Path $vswhere)) { throw 'vswhere missing' }
$vsroot = (& $vswhere -latest -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath | Select-Object -First 1)
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($vsroot)) { throw 'MSVC x64 toolchain missing' }
$vsdev = Join-Path $vsroot.Trim() 'Common7/Tools/VsDevCmd.bat'
$temp = if ($env:RUNNER_TEMP) { $env:RUNNER_TEMP } else { [IO.Path]::GetTempPath() }
$cmd = Join-Path $temp 'wal2json-msvc-build.cmd'
$obj = Join-Path $UpstreamDir 'wal2json.obj'
$dll = Join-Path $UpstreamDir 'wal2json.dll'
$lines = @(
    '@echo off',
    ('call "' + $vsdev + '" -arch=x64 -host_arch=x64'),
    'if errorlevel 1 exit /b %errorlevel%',
    ('cd /d "' + $UpstreamDir + '"'),
    ('cl /nologo /O2 /MD /DWIN32 /D__WINDOWS__ /DWIN32_NO_STATUS /D_CRT_SECURE_NO_WARNINGS /D_CRT_NONSTDC_NO_WARNINGS /I"{0}" /I"{1}" /I"{2}" /I"{3}" /c "{4}" /Fo"{5}"' -f
        (Join-Path $PgRoot 'include/server/port/win32_msvc'),(Join-Path $PgRoot 'include/server/port/win32'),
        (Join-Path $PgRoot 'include/server'),(Join-Path $PgRoot 'include'),$source,$obj),
    'if errorlevel 1 exit /b %errorlevel%',
    ('link /nologo /DLL /MACHINE:X64 /OUT:"{0}" /DEF:"{1}" "{2}" "{3}"' -f
        $dll,$def,$obj,(Join-Path $PgRoot 'lib/postgres.lib')),
    'if errorlevel 1 exit /b %errorlevel%',
    ('dumpbin /nologo /exports "' + $dll + '"'),
    'if errorlevel 1 exit /b %errorlevel%'
)
[IO.File]::WriteAllLines($cmd,[string[]]$lines,[Text.Encoding]::ASCII)
$output = @(& cmd.exe /d /c $cmd)
if ($LASTEXITCODE -ne 0 -or -not (Test-Path $dll)) {
    $output | ForEach-Object { Write-Host $_ }
    throw 'wal2json MSVC compile/link/dumpbin failed (do not waive)'
}
$dump = $output -join [Environment]::NewLine
foreach ($symbol in @('Pg_magic_func','_PG_output_plugin_init')) {
    if ($dump -notmatch ('(?m)\s' + [regex]::Escape($symbol) + '\s*$')) {
        throw "Required output plugin export missing: $symbol"
    }
}
Write-Host "Built pinned wal2json 2.6 with output plugin entry point"
