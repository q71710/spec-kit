#!/usr/bin/env pwsh
# 這個腳本的目的：
# 用於檢查功能分支的前置條件是否滿足。
# 它會驗證功能目錄與計畫文件是否存在，
# 並根據需要輸出相關的檔案資訊。

[CmdletBinding()]
param([switch]$Json)

# 設定錯誤處理策略
$ErrorActionPreference = 'Stop'

# 載入共用函數與變數
. "$PSScriptRoot/common.ps1"

# 獲取功能相關的路徑資訊
$paths = Get-FeaturePathsEnv

# 檢查當前分支是否為有效的功能分支
if (-not (Test-FeatureBranch -Branch $paths.CURRENT_BRANCH)) { exit 1 }

# 驗證功能目錄是否存在
if (-not (Test-Path $paths.FEATURE_DIR -PathType Container)) {
    Write-Output "ERROR: Feature directory not found: $($paths.FEATURE_DIR)"
    Write-Output "Run /specify first to create the feature structure."
    exit 1
}

# 驗證計畫文件是否存在
if (-not (Test-Path $paths.IMPL_PLAN -PathType Leaf)) {
    Write-Output "ERROR: plan.md not found in $($paths.FEATURE_DIR)"
    Write-Output "Run /plan first to create the plan."
    exit 1
}

# 如果啟用了 JSON 模式，輸出 JSON 格式的結果
if ($Json) {
    $docs = @()
    if (Test-Path $paths.RESEARCH) { $docs += 'research.md' }
    if (Test-Path $paths.DATA_MODEL) { $docs += 'data-model.md' }
    if ((Test-Path $paths.CONTRACTS_DIR) -and (Get-ChildItem -Path $paths.CONTRACTS_DIR -ErrorAction SilentlyContinue | Select-Object -First 1)) { $docs += 'contracts/' }
    if (Test-Path $paths.QUICKSTART) { $docs += 'quickstart.md' }
    [PSCustomObject]@{ FEATURE_DIR=$paths.FEATURE_DIR; AVAILABLE_DOCS=$docs } | ConvertTo-Json -Compress
} else {
    # 否則以人類可讀的格式輸出結果
    Write-Output "FEATURE_DIR:$($paths.FEATURE_DIR)"
    Write-Output "AVAILABLE_DOCS:"
    Test-FileExists -Path $paths.RESEARCH -Description 'research.md' | Out-Null
    Test-FileExists -Path $paths.DATA_MODEL -Description 'data-model.md' | Out-Null
    Test-DirHasFiles -Path $paths.CONTRACTS_DIR -Description 'contracts/' | Out-Null
    Test-FileExists -Path $paths.QUICKSTART -Description 'quickstart.md' | Out-Null
}
