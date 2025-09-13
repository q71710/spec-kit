#!/usr/bin/env pwsh
# 這個腳本的目的：
# 用於獲取當前功能分支的相關路徑資訊。
# 它會檢查功能分支名稱是否有效，
# 並輸出專案根目錄、功能目錄與相關文件的路徑。

param()

# 設定錯誤處理策略
$ErrorActionPreference = 'Stop'

# 載入共用函數與變數
. "$PSScriptRoot/common.ps1"

# 獲取功能相關的路徑資訊
$paths = Get-FeaturePathsEnv

# 檢查當前分支是否為有效的功能分支
if (-not (Test-FeatureBranch -Branch $paths.CURRENT_BRANCH)) { exit 1 }

# 輸出相關路徑資訊
Write-Output "REPO_ROOT: $($paths.REPO_ROOT)"
Write-Output "BRANCH: $($paths.CURRENT_BRANCH)"
Write-Output "FEATURE_DIR: $($paths.FEATURE_DIR)"
Write-Output "FEATURE_SPEC: $($paths.FEATURE_SPEC)"
Write-Output "IMPL_PLAN: $($paths.IMPL_PLAN)"
Write-Output "TASKS: $($paths.TASKS)"
