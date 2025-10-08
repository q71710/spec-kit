# AGENTS.md

## About Spec Kit and Specify

**GitHub Spec Kit** is a comprehensive toolkit for implementing Spec-Driven Development (SDD) - a methodology that emphasizes creating clear specifications before implementation. The toolkit includes templates, scripts, and workflows that guide development teams through a structured approach to building software.

**Specify CLI** is the command-line interface that bootstraps projects with the Spec Kit framework. It sets up the necessary directory structures, templates, and AI agent integrations to support the Spec-Driven Development workflow.

The toolkit supports multiple AI coding assistants, allowing teams to use their preferred tools while maintaining consistent project structure and development practices.

---

## General practices

- Any changes to `__init__.py` for the Specify CLI require a version rev in `pyproject.toml` and addition of entries to `CHANGELOG.md`.

````markdown
# AGENTS.md

## 關於 Spec Kit 和 Specify

**GitHub Spec Kit** 是一個實作規格驅動開發（SDD）的綜合工具包 - 這是一種強調在實作之前建立清晰規格的方法論。此工具包包含範本、腳本和工作流程，引導開發團隊透過結構化方法建構軟體。

**Specify CLI** 是使用 Spec Kit 框架引導專案的命令列介面。它設定必要的目錄結構、範本和 AI 代理整合，以支援規格驅動開發工作流程。

此工具包支援多種 AI 編碼助理，讓團隊可以使用他們偏好的工具，同時維持一致的專案結構和開發實務。

---

## 一般實務

- 對 Specify CLI 的 `__init__.py` 的任何變更都需要在 `pyproject.toml` 中更新版本並在 `CHANGELOG.md` 中新增條目。

## 新增代理支援

本節說明如何為 Specify CLI 新增新的 AI 代理/助理支援。在將新的 AI 工具整合到規格驅動開發工作流程時，請使用本指南作為參考。

### 概述

Specify 透過在初始化專案時生成代理特定的命令檔案和目錄結構來支援多個 AI 代理。每個代理都有自己的慣例：

- **命令檔案格式**（Markdown、TOML 等）
- **目錄結構**（`.claude/commands/`、`.windsurf/workflows/` 等）
- **命令調用模式**（斜線命令、CLI 工具等）
- **參數傳遞慣例**（`$ARGUMENTS`、`{{args}}` 等）

### 目前支援的代理

| 代理 | 目錄 | 格式 | CLI 工具 | 描述 |
|-------|-----------|---------|----------|-------------|
| **Claude Code** | `.claude/commands/` | Markdown | `claude` | Anthropic 的 Claude Code CLI |
| **Gemini CLI** | `.gemini/commands/` | TOML | `gemini` | Google 的 Gemini CLI |
| **GitHub Copilot** | `.github/prompts/` | Markdown | N/A（基於 IDE） | VS Code 中的 GitHub Copilot |
| **Cursor** | `.cursor/commands/` | Markdown | `cursor-agent` | Cursor CLI |
| **Qwen Code** | `.qwen/commands/` | TOML | `qwen` | 阿里巴巴的 Qwen Code CLI |
| **opencode** | `.opencode/command/` | Markdown | `opencode` | opencode CLI |
| **Windsurf** | `.windsurf/workflows/` | Markdown | N/A（基於 IDE） | Windsurf IDE 工作流程 |
| **Amazon Q Developer CLI** | `.amazonq/prompts/` | Markdown | `q` | Amazon Q Developer CLI |


### 逐步整合指南

遵循這些步驟來新增新代理（以 Windsurf 為例）：

#### 1. 更新 AI_CHOICES 常數

在 `src/specify_cli/__init__.py` 中將新代理新增到 `AI_CHOICES` 字典：

```python
AI_CHOICES = {
    "copilot": "GitHub Copilot",
    "claude": "Claude Code", 
    "gemini": "Gemini CLI",
    "cursor": "Cursor",
    "qwen": "Qwen Code",
    "opencode": "opencode",
    "windsurf": "Windsurf",
    "q": "Amazon Q Developer CLI"  # Add new agent here
}
```

Also update the `agent_folder_map` in the same file to include the new agent's folder for the security notice:

```python
agent_folder_map = {
    "claude": ".claude/",
    "gemini": ".gemini/",
    "cursor": ".cursor/",
    "qwen": ".qwen/",
    "opencode": ".opencode/",
    "codex": ".codex/",
    "windsurf": ".windsurf/",  
    "kilocode": ".kilocode/",
    "auggie": ".auggie/",
    "copilot": ".github/",
    "q": ".amazonq/" # Add new agent folder here
}
```

#### 2. Update CLI Help Text

Update all help text and examples to include the new agent:

- Command option help: `--ai` parameter description
- Function docstrings and examples
- Error messages with agent lists

#### 3. Update README Documentation

Update the **Supported AI Agents** section in `README.md` to include the new agent:

- Add the new agent to the table with appropriate support level (Full/Partial)
- Include the agent's official website link
- Add any relevant notes about the agent's implementation
- Ensure the table formatting remains aligned and consistent

#### 4. Update Release Package Script

Modify `.github/workflows/scripts/create-release-packages.sh`:

##### Add to ALL_AGENTS array:
```bash
ALL_AGENTS=(claude gemini copilot cursor qwen opencode windsurf q)
```

##### Add case statement for directory structure:
```bash
case $agent in
  # ... existing cases ...
  windsurf)
    mkdir -p "$base_dir/.windsurf/workflows"
    generate_commands windsurf md "\$ARGUMENTS" "$base_dir/.windsurf/workflows" "$script" ;;
esac
```

#### 4. Update GitHub Release Script

Modify `.github/workflows/scripts/create-github-release.sh` to include the new agent's packages:

```bash
gh release create "$VERSION" \
  # ... existing packages ...
  .genreleases/spec-kit-template-windsurf-sh-"$VERSION".zip \
  .genreleases/spec-kit-template-windsurf-ps-"$VERSION".zip \
  # Add new agent packages here
```

#### 5. Update Agent Context Scripts

##### Bash script (`scripts/bash/update-agent-context.sh`):

Add file variable:
```bash
WINDSURF_FILE="$REPO_ROOT/.windsurf/rules/specify-rules.md"
```

Add to case statement:
```bash
case "$AGENT_TYPE" in
  # ... existing cases ...
  windsurf) update_agent_file "$WINDSURF_FILE" "Windsurf" ;;
  "") 
    # ... existing checks ...
    [ -f "$WINDSURF_FILE" ] && update_agent_file "$WINDSURF_FILE" "Windsurf";
    # Update default creation condition
    ;;
esac
```

##### PowerShell script (`scripts/powershell/update-agent-context.ps1`):

Add file variable:
```powershell
$windsurfFile = Join-Path $repoRoot '.windsurf/rules/specify-rules.md'
```

Add to switch statement:
```powershell
switch ($AgentType) {
    # ... existing cases ...
    'windsurf' { Update-AgentFile $windsurfFile 'Windsurf' }
    '' {
        foreach ($pair in @(
            # ... existing pairs ...
            @{file=$windsurfFile; name='Windsurf'}
        )) {
            if (Test-Path $pair.file) { Update-AgentFile $pair.file $pair.name }
        }
        # Update default creation condition
    }
}
```

#### 6. Update CLI Tool Checks (Optional)

For agents that require CLI tools, add checks in the `check()` command and agent validation:

```python
# In check() command
tracker.add("windsurf", "Windsurf IDE (optional)")
windsurf_ok = check_tool_for_tracker("windsurf", "https://windsurf.com/", tracker)

# In init validation (only if CLI tool required)
elif selected_ai == "windsurf":
    if not check_tool("windsurf", "Install from: https://windsurf.com/"):
        console.print("[red]Error:[/red] Windsurf CLI is required for Windsurf projects")
        agent_tool_missing = True
```

**注意**：對基於 IDE 的代理（Copilot、Windsurf）跳過 CLI 檢查。

## 代理類別

### 基於 CLI 的代理
需要安裝命令列工具：
- **Claude Code**：`claude` CLI
- **Gemini CLI**：`gemini` CLI  
- **Cursor**：`cursor-agent` CLI
- **Qwen Code**：`qwen` CLI
- **opencode**：`opencode` CLI

### 基於 IDE 的代理
在整合開發環境中運作：
- **GitHub Copilot**：內建於 VS Code/相容編輯器
- **Windsurf**：內建於 Windsurf IDE

## 命令檔案格式

### Markdown 格式
使用者：Claude、Cursor、opencode、Windsurf、Amazon Q Developer

```markdown
---
description: "命令描述"
---

包含 {SCRIPT} 和 $ARGUMENTS 佔位符的命令內容。
```

### TOML 格式
使用者：Gemini、Qwen

```toml
description = "命令描述"

prompt = """
包含 {SCRIPT} 和 {{args}} 佔位符的命令內容。
"""
```

## 目錄慣例

- **CLI 代理**：通常為 `.<agent-name>/commands/`
- **IDE 代理**：遵循 IDE 特定模式：
  - Copilot：`.github/prompts/`
  - Cursor：`.cursor/commands/`
  - Windsurf：`.windsurf/workflows/`

## 參數模式

不同的代理使用不同的參數佔位符：
- **基於 Markdown/提示**：`$ARGUMENTS`
- **基於 TOML**：`{{args}}`
- **腳本佔位符**：`{SCRIPT}`（替換為實際腳本路徑）
- **代理佔位符**：`__AGENT__`（替換為代理名稱）

## 測試新代理整合

1. **建置測試**：在本地執行套件建立腳本
2. **CLI 測試**：測試 `specify init --ai <agent>` 命令
3. **檔案生成**：驗證正確的目錄結構和檔案
4. **命令驗證**：確保生成的命令與代理一起運作
5. **上下文更新**：測試代理上下文更新腳本

## 常見陷阱

1. **忘記更新腳本**：必須同時更新 bash 和 PowerShell 腳本
2. **遺漏 CLI 檢查**：只對實際有 CLI 工具的代理新增檢查
3. **錯誤的參數格式**：為每種代理類型使用正確的佔位符格式
4. **目錄命名**：完全遵循代理特定的慣例
5. **幫助文字不一致**：一致地更新所有面向使用者的文字

## 未來考量

新增新代理時：
- 考慮代理的原生命令/工作流程模式
- 確保與規格驅動開發流程的相容性
- 記錄任何特殊需求或限制
- 以學到的經驗更新本指南

---

*每當新增新代理時，應更新此文件以保持準確性和完整性。*