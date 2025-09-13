#!/usr/bin/env pwsh
# 這個腳本的目的：
# 用於設置功能分支的實作計畫環境。
# 它會檢查當前分支名稱是否符合功能分支的命名規範，
# 並根據模板生成對應的實作計畫文件，
# 最後輸出相關的環境變數資訊。

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

# 建立功能目錄（如果不存在）
New-Item -ItemType Directory -Path $paths.FEATURE_DIR -Force | Out-Null

# 設定模板文件的路徑
$template = Join-Path $paths.REPO_ROOT 'templates/plan-template.md'

# 如果模板文件存在，將其複製到實作計畫路徑
if (Test-Path $template) { Copy-Item $template $paths.IMPL_PLAN -Force }

# 如果啟用了 JSON 模式，輸出 JSON 格式的結果
if ($Json) {
    [PSCustomObject]@{ FEATURE_SPEC=$paths.FEATURE_SPEC; IMPL_PLAN=$paths.IMPL_PLAN; SPECS_DIR=$paths.FEATURE_DIR; BRANCH=$paths.CURRENT_BRANCH } | ConvertTo-Json -Compress
} else {
    # 否則以人類可讀的格式輸出結果
    Write-Output "FEATURE_SPEC: $($paths.FEATURE_SPEC)"
    Write-Output "IMPL_PLAN: $($paths.IMPL_PLAN)"
    Write-Output "SPECS_DIR: $($paths.FEATURE_DIR)"
    Write-Output "BRANCH: $($paths.CURRENT_BRANCH)"
}
