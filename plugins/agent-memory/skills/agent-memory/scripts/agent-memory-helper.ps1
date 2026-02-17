# agent-memory-helper.ps1
# agent-memoryスキル用ヘルパースクリプト
#
# アクション:
#   generate-id  - tracking ID生成 (AM-YYYYMMDD-NNN)
#   ensure-dir   - ディレクトリ作成 (memories配下のみ)
#   save-prepare - ディレクトリ作成 + tracking ID生成を1回で実行

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("generate-id", "ensure-dir", "save-prepare")]
    [string]$Action,

    [string]$Path = ".claude\skills\agent-memory\memories"
)

$allowedBase = ".claude\skills\agent-memory\memories"

function Get-NextTrackingId {
    param([string]$MemoriesPath)

    $datePrefix = "AM-$(Get-Date -Format 'yyyyMMdd')"
    $existingIds = @()

    if (Test-Path $MemoriesPath) {
        $existingIds = Get-ChildItem $MemoriesPath -Recurse -Filter "*.md" -ErrorAction SilentlyContinue |
            Select-String "^tracking_id: $datePrefix" -ErrorAction SilentlyContinue |
            ForEach-Object { ($_.Line -split '-')[-1] } |
            Where-Object { $_ -match '^\d{3}$' } |
            Sort-Object { [int]$_ }
    }

    $nextNum = if ($existingIds.Count -gt 0) {
        ([int]($existingIds[-1]) + 1).ToString("000")
    } else {
        "001"
    }

    return "$datePrefix-$nextNum"
}

function Invoke-EnsureDirectory {
    param([string]$DirPath)

    if (-not $DirPath.Contains($allowedBase)) {
        throw "Denied: Only paths under $allowedBase are allowed"
    }

    if (-not (Test-Path $DirPath)) {
        New-Item -ItemType Directory -Path $DirPath -Force | Out-Null
        Write-Output "Created: $DirPath"
    } else {
        Write-Output "Exists: $DirPath"
    }
}

try {
    switch ($Action) {
        "generate-id" {
            $id = Get-NextTrackingId -MemoriesPath $Path
            Write-Output "Assigned: $id"
        }
        "ensure-dir" {
            Invoke-EnsureDirectory -DirPath $Path
        }
        "save-prepare" {
            Invoke-EnsureDirectory -DirPath $Path
            $id = Get-NextTrackingId -MemoriesPath $allowedBase
            Write-Output "Assigned: $id"
        }
    }
} catch {
    Write-Error "Error: $_"
    if ($Action -in @("generate-id", "save-prepare")) {
        $fallbackId = "AM-$(Get-Date -Format 'yyyyMMdd')-001"
        Write-Output "Assigned: $fallbackId"
    }
}
