#!/usr/bin/env pwsh
# 這個腳本的目的：
# 用於創建新的功能分支，並生成對應的目錄結構與模板文件。
# 它會自動分配功能編號，建立分支與目錄，
# 並根據模板生成規範文件。

[CmdletBinding()]
param(
    [switch]$Json,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$FeatureDescription
)

# 設定錯誤處理策略
$ErrorActionPreference = 'Stop'

# 驗證功能描述是否提供
if (-not $FeatureDescription -or $FeatureDescription.Count -eq 0) {
    Write-Error "Usage: ./create-new-feature.ps1 [-Json] <feature description>"; exit 1
}
$featureDesc = ($FeatureDescription -join ' ').Trim()

# 獲取專案根目錄
$repoRoot = git rev-parse --show-toplevel
# 設定規範目錄
$specsDir = Join-Path $repoRoot 'specs'
# 建立規範目錄（如果不存在）
New-Item -ItemType Directory -Path $specsDir -Force | Out-Null

# 找到當前最高的功能編號
$highest = 0
if (Test-Path $specsDir) {
    Get-ChildItem -Path $specsDir -Directory | ForEach-Object {
        if ($_.Name -match '^\d{3}') {
            $num = [int]$matches[1]
            if ($num -gt $highest) { $highest = $num }
        }
    }
}

# 計算下一個功能編號
$next = $highest + 1
$featureNum = ('{0:000}' -f $next)

# 根據功能描述生成分支名稱
$branchName = $featureDesc.ToLower() -replace '[^a-z0-9]', '-' -replace '-{2,}', '-' -replace '^-', '' -replace '-$', ''
$words = ($branchName -split '-') | Where-Object { $_ } | Select-Object -First 3
$branchName = "$featureNum-$([string]::Join('-', $words))"

# 創建新的 Git 分支
git checkout -b $branchName | Out-Null

# 設定功能目錄
$featureDir = Join-Path $specsDir $branchName
# 建立功能目錄
New-Item -ItemType Directory -Path $featureDir -Force | Out-Null

# 設定模板文件與規範文件路徑
$template = Join-Path $repoRoot 'templates/spec-template.md'
$specFile = Join-Path $featureDir 'spec.md'
# 如果模板文件存在，複製到規範文件路徑；否則建立空白文件
if (Test-Path $template) { Copy-Item $template $specFile -Force } else { New-Item -ItemType File -Path $specFile | Out-Null }

# 如果啟用了 JSON 模式，輸出 JSON 格式的結果
if ($Json) {
    $obj = [PSCustomObject]@{ BRANCH_NAME = $branchName; SPEC_FILE = $specFile; FEATURE_NUM = $featureNum }
    $obj | ConvertTo-Json -Compress
} else {
    # 否則以人類可讀的格式輸出結果
    Write-Output "BRANCH_NAME: $branchName"
    Write-Output "SPEC_FILE: $specFile"
    Write-Output "FEATURE_NUM: $featureNum"
}
