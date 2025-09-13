#!/usr/bin/env pwsh
# 這個腳本的目的：
# 提供所有 PowerShell 腳本共用的函數與變數。
# 包括獲取專案根目錄、當前分支名稱，
# 驗證功能分支名稱，以及生成功能相關的路徑資訊。

# 獲取專案的根目錄
function Get-RepoRoot {
    git rev-parse --show-toplevel
}

# 獲取當前分支名稱
function Get-CurrentBranch {
    git rev-parse --abbrev-ref HEAD
}

# 驗證功能分支名稱是否符合命名規範
function Test-FeatureBranch {
    param([string]$Branch)
    if ($Branch -notmatch '^[0-9]{3}-') {
        Write-Output "ERROR: Not on a feature branch. Current branch: $Branch"
        Write-Output "Feature branches should be named like: 001-feature-name"
        return $false
    }
    return $true
}

# 獲取功能目錄的路徑
function Get-FeatureDir {
    param([string]$RepoRoot, [string]$Branch)
    Join-Path $RepoRoot "specs/$Branch"
}

# 生成功能相關的路徑資訊
function Get-FeaturePathsEnv {
    $repoRoot = Get-RepoRoot
    $currentBranch = Get-CurrentBranch
    $featureDir = Get-FeatureDir -RepoRoot $repoRoot -Branch $currentBranch
    [PSCustomObject]@{
        REPO_ROOT    = $repoRoot
        CURRENT_BRANCH = $currentBranch
        FEATURE_DIR  = $featureDir
        FEATURE_SPEC = Join-Path $featureDir 'spec.md'
        IMPL_PLAN    = Join-Path $featureDir 'plan.md'
        TASKS        = Join-Path $featureDir 'tasks.md'
        RESEARCH     = Join-Path $featureDir 'research.md'
        DATA_MODEL   = Join-Path $featureDir 'data-model.md'
        QUICKSTART   = Join-Path $featureDir 'quickstart.md'
        CONTRACTS_DIR = Join-Path $featureDir 'contracts'
    }
}

# 檢查檔案是否存在
function Test-FileExists {
    param([string]$Path, [string]$Description)
    if (Test-Path -Path $Path -PathType Leaf) {
        Write-Output "  ✓ $Description"
        return $true
    } else {
        Write-Output "  ✗ $Description"
        return $false
    }
}

# 檢查目錄是否存在且非空
function Test-DirHasFiles {
    param([string]$Path, [string]$Description)
    if ((Test-Path -Path $Path -PathType Container) -and (Get-ChildItem -Path $Path -ErrorAction SilentlyContinue | Where-Object { -not $_.PSIsContainer } | Select-Object -First 1)) {
        Write-Output "  ✓ $Description"
        return $true
    } else {
        Write-Output "  ✗ $Description"
        return $false
    }
}
