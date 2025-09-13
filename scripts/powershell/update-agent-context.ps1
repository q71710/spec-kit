#!/usr/bin/env pwsh
# 這個腳本的目的：
# 用於更新代理（Agent）的上下文文件。
# 它會根據功能分支的計畫文件提取相關資訊，
# 並更新或創建對應的代理上下文文件。

[CmdletBinding()]
param([string]$AgentType)

# 設定錯誤處理策略
$ErrorActionPreference = 'Stop'

# 獲取專案根目錄與當前分支名稱
$repoRoot = git rev-parse --show-toplevel
$currentBranch = git rev-parse --abbrev-ref HEAD

# 設定功能目錄與計畫文件路徑
$featureDir = Join-Path $repoRoot "specs/$currentBranch"
$newPlan = Join-Path $featureDir 'plan.md'

# 驗證計畫文件是否存在
if (-not (Test-Path $newPlan)) { Write-Error "ERROR: No plan.md found at $newPlan"; exit 1 }

# 設定代理上下文文件的路徑
$claudeFile = Join-Path $repoRoot 'CLAUDE.md'
$geminiFile = Join-Path $repoRoot 'GEMINI.md'
$copilotFile = Join-Path $repoRoot '.github/copilot-instructions.md'

# 顯示更新代理上下文文件的訊息
Write-Output "=== Updating agent context files for feature $currentBranch ==="

# 定義從計畫文件中提取值的函數
function Get-PlanValue($pattern) {
    if (-not (Test-Path $newPlan)) { return '' }
    $line = Select-String -Path $newPlan -Pattern $pattern | Select-Object -First 1
    if ($line) { return ($line.Line -replace "^\*\*$pattern\*\*: ", '') }
    return ''
}

# 從計畫文件中提取相關資訊
$newLang = Get-PlanValue 'Language/Version'
$newFramework = Get-PlanValue 'Primary Dependencies'
$newTesting = Get-PlanValue 'Testing'
$newDb = Get-PlanValue 'Storage'
$newProjectType = Get-PlanValue 'Project Type'

# 定義初始化代理文件的函數
function Initialize-AgentFile($targetFile, $agentName) {
    if (Test-Path $targetFile) { return }
    $template = Join-Path $repoRoot 'templates/agent-file-template.md'
    if (-not (Test-Path $template)) { Write-Error "Template not found: $template"; return }
    $content = Get-Content $template -Raw
    $content = $content.Replace('[PROJECT NAME]', (Split-Path $repoRoot -Leaf))
    $content = $content.Replace('[DATE]', (Get-Date -Format 'yyyy-MM-dd'))
    $content = $content.Replace('[EXTRACTED FROM ALL PLAN.MD FILES]', "- $newLang + $newFramework ($currentBranch)")
    if ($newProjectType -match 'web') { $structure = "backend/`nfrontend/`ntests/" } else { $structure = "src/`ntests/" }
    $content = $content.Replace('[ACTUAL STRUCTURE FROM PLANS]', $structure)
    if ($newLang -match 'Python') { $commands = 'cd src && pytest && ruff check .' }
    elseif ($newLang -match 'Rust') { $commands = 'cargo test && cargo clippy' }
    elseif ($newLang -match 'JavaScript|TypeScript') { $commands = 'npm test && npm run lint' }
    else { $commands = "# Add commands for $newLang" }
    $content = $content.Replace('[ONLY COMMANDS FOR ACTIVE TECHNOLOGIES]', $commands)
    $content = $content.Replace('[LANGUAGE-SPECIFIC, ONLY FOR LANGUAGES IN USE]', "${newLang}: Follow standard conventions")
    $content = $content.Replace('[LAST 3 FEATURES AND WHAT THEY ADDED]', "- ${currentBranch}: Added ${newLang} + ${newFramework}")
    $content | Set-Content $targetFile -Encoding UTF8
}

# 定義更新代理文件的函數
function Update-AgentFile($targetFile, $agentName) {
    if (-not (Test-Path $targetFile)) { Initialize-AgentFile $targetFile $agentName; return }
    $content = Get-Content $targetFile -Raw
    if ($newLang -and ($content -notmatch [regex]::Escape($newLang))) { $content = $content -replace '(## Active Technologies\n)', "`$1- $newLang + $newFramework ($currentBranch)`n" }
    if ($newDb -and $newDb -ne 'N/A' -and ($content -notmatch [regex]::Escape($newDb))) { $content = $content -replace '(## Active Technologies\n)', "`$1- $newDb ($currentBranch)`n" }
    if ($content -match '## Recent Changes\n([\s\S]*?)(\n\n|$)') {
        $changesBlock = $matches[1].Trim().Split("`n")
        $changesBlock = ,"- $currentBranch: Added $newLang + $newFramework" + $changesBlock
        $changesBlock = $changesBlock | Where-Object { $_ } | Select-Object -First 3
        $joined = ($changesBlock -join "`n")
        $content = [regex]::Replace($content, '## Recent Changes\n([\s\S]*?)(\n\n|$)', "## Recent Changes`n$joined`n`n")
    }
    $content = [regex]::Replace($content, 'Last updated: \d{4}-\d{2}-\d{2}', "Last updated: $(Get-Date -Format 'yyyy-MM-dd')")
    $content | Set-Content $targetFile -Encoding UTF8
    Write-Output "✅ $agentName context file updated successfully"
}

# 根據代理類型更新對應的上下文文件
switch ($AgentType) {
    'claude' { Update-AgentFile $claudeFile 'Claude Code' }
    'gemini' { Update-AgentFile $geminiFile 'Gemini CLI' }
    'copilot' { Update-AgentFile $copilotFile 'GitHub Copilot' }
    '' {
        foreach ($pair in @(@{file=$claudeFile; name='Claude Code'}, @{file=$geminiFile; name='Gemini CLI'}, @{file=$copilotFile; name='GitHub Copilot'})) {
            if (Test-Path $pair.file) { Update-AgentFile $pair.file $pair.name }
        }
        if (-not (Test-Path $claudeFile) -and -not (Test-Path $geminiFile) -and -not (Test-Path $copilotFile)) {
            Write-Output 'No agent context files found. Creating Claude Code context file by default.'
            Update-AgentFile $claudeFile 'Claude Code'
        }
    }
    Default { Write-Error "ERROR: Unknown agent type '$AgentType'. Use: claude, gemini, copilot, or leave empty for all."; exit 1 }
}

# 顯示更新摘要
Write-Output ''
Write-Output 'Summary of changes:'
if ($newLang) { Write-Output "- Added language: $newLang" }
if ($newFramework) { Write-Output "- Added framework: $newFramework" }
if ($newDb -and $newDb -ne 'N/A') { Write-Output "- Added database: $newDb" }

Write-Output ''
Write-Output 'Usage: ./update-agent-context.ps1 [claude|gemini|copilot]'
