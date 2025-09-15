# 安裝指南

## 先決條件

- **Linux/macOS** (或 Windows；現在支援 PowerShell 指令碼，無需 WSL)
- AI 編碼代理：[Claude Code](https://www.anthropic.com/claude-code)、[GitHub Copilot](https://code.visualstudio.com/) 或 [Gemini CLI](https://github.com/google-gemini/gemini-cli)
- [uv](https://docs.astral.sh/uv/) 用於套件管理
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

## 安裝

### 初始化一個新專案

最簡單的入門方法是初始化一個新專案：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <專案名稱>
```

或在目前目錄中初始化：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init --here
```

### 指定 AI 代理

您可以在初始化期間主動指定您的 AI 代理：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <專案名稱> --ai claude
uvx --from git+https://github.com/github/spec-kit.git specify init <專案名稱> --ai gemini
uvx --from git+https://github.com/github/spec-kit.git specify init <專案名稱> --ai copilot
```

### 指定指令碼類型 (Shell vs PowerShell)

所有自動化指令碼現在都有 Bash (`.sh`) 和 PowerShell (`.ps1`) 兩種版本。

自動行為：
- Windows 預設：`ps`
- 其他作業系統預設：`sh`
- 互動模式：除非您傳遞 `--script`，否則系統會提示您

強制指定特定的指令碼類型：
```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <專案名稱> --script sh
uvx --from git+https://github.com/github/spec-kit.git specify init <專案名稱> --script ps
```

### 忽略代理工具檢查

如果您希望在不檢查正確工具的情況下取得範本：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <專案名稱> --ai claude --ignore-agent-tools
```

## 驗證

初始化後，您應該會在您的 AI 代理中看到以下可用命令：
- `/specify` - 建立規格
- `/plan` - 產生實作計畫
- `/tasks` - 分解為可執行的任務

`.specify/scripts` 目錄將同時包含 `.sh` 和 `.ps1` 指令碼。

## 疑難排解

### Linux 上的 Git 認證管理員

如果您在 Linux 上遇到 Git 身份驗證問題，可以安裝 Git 認證管理員：

```bash
#!/usr/bin/env bash
set -e
echo "正在下載 Git Credential Manager v2.6.1..."
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.deb
echo "正在安裝 Git Credential Manager..."
sudo dpkg -i gcm-linux_amd64.2.6.1.deb
echo "正在設定 Git 使用 GCM..."
git config --global credential.helper manager
echo "正在清理..."
rm gcm-linux_amd64.2.6.1.deb
```
