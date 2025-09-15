````markdown
# 本地開發指南

本指南說明如何在本地迭代 `specify` CLI，而無需先發布版本或提交到 `main`。

> 指令碼現在有 Bash (`.sh`) 和 PowerShell (`.ps1`) 兩種版本。CLI 會根據作業系統自動選擇，除非您傳遞 `--script sh|ps`。

## 1. 克隆並切換分支

```bash
git clone https://github.com/github/spec-kit.git
cd spec-kit
# 在功能分支上工作
git checkout -b your-feature-branch
```

## 2. 直接執行 CLI (最快的回饋)

您可以透過模組進入點執行 CLI，無需安裝任何東西：

```bash
# 從 repo 根目錄
python -m src.specify_cli --help
python -m src.specify_cli init demo-project --ai claude --ignore-agent-tools --script sh
```

如果您偏好呼叫指令碼檔案樣式 (使用 shebang)：

```bash
python src/specify_cli/__init__.py init demo-project --script ps
```

## 3. 使用可編輯安裝 (隔離環境)

使用 `uv` 建立一個隔離的環境，以便依賴項的解析方式與終端使用者完全相同：

```bash
# 建立並啟用虛擬環境 (uv 會自動管理 .venv)
uv venv
source .venv/bin/activate  # 或在 Windows PowerShell 中：.venv\Scripts\Activate.ps1

# 以可編輯模式安裝專案
uv pip install -e .

# 現在 'specify' 進入點可用
specify --help
```

由於是可編輯模式，在程式碼編輯後重新執行無需重新安裝。

## 4. 直接從 Git (目前分支) 使用 uvx 呼叫

`uvx` 可以從本地路徑 (或 Git ref) 執行，以模擬使用者流程：

```bash
uvx --from . specify init demo-uvx --ai copilot --ignore-agent-tools --script sh
```

您也可以在不合併的情況下將 uvx 指向特定分支：

```bash
# 先推送您的工作分支
git push origin your-feature-branch
uvx --from git+https://github.com/github/spec-kit.git@your-feature-branch specify init demo-branch-test --script ps
```

### 4a. 絕對路徑 uvx (從任何地方執行)

如果您在另一個目錄中，請使用絕對路徑而不是 `.`：

```bash
uvx --from /mnt/c/GitHub/spec-kit specify --help
uvx --from /mnt/c/GitHub/spec-kit specify init demo-anywhere --ai copilot --ignore-agent-tools --script sh
```

為了方便，可以設定一個環境變數：
```bash
export SPEC_KIT_SRC=/mnt/c/GitHub/spec-kit
uvx --from "$SPEC_KIT_SRC" specify init demo-env --ai copilot --ignore-agent-tools --script ps
```

(可選) 定義一個 shell 函式：
```bash
specify-dev() { uvx --from /mnt/c/GitHub/spec-kit specify "$@"; }
# 然後
specify-dev --help
```

## 5. 測試指令碼權限邏輯

執行 `init` 後，檢查 shell 指令碼在 POSIX 系統上是否可執行：

```bash
ls -l scripts | grep .sh
# 預期擁有者有執行權限 (例如 -rwxr-xr-x)
```
在 Windows 上，您將改用 `.ps1` 指令碼 (無需 chmod)。

## 6. 執行 Lint / 基本檢查 (新增您自己的)

目前沒有捆綁強制的 lint 設定，但您可以快速檢查可匯入性：
```bash
python -c "import specify_cli; print('Import OK')"
```

## 7. 本地建置 Wheel (可選)

在發布前驗證打包：

```bash
uv build
ls dist/
```
如果需要，可以將建置的產物安裝到一個全新的臨時環境中。

## 8. 使用臨時工作區

在一個髒目錄中測試 `init --here` 時，建立一個臨時工作區：

```bash
mkdir /tmp/spec-test && cd /tmp/spec-test
python -m src.specify_cli init --here --ai claude --ignore-agent-tools --script sh  # 如果 repo 已複製到此處
```
或者，如果您想要一個更輕量的沙箱，只複製修改過的 CLI 部分。

## 9. 偵錯網路 / TLS 略過

如果您在實驗時需要繞過 TLS 驗證：

```bash
specify check --skip-tls
specify init demo --skip-tls --ai gemini --ignore-agent-tools --script ps
```
(僅用於本地實驗。)

## 10. 快速編輯循環摘要

| 操作                        | 命令                                            |
| --------------------------- | ----------------------------------------------- |
| 直接執行 CLI                | `python -m src.specify_cli --help`              |
| 可編輯安裝                  | `uv pip install -e .` 然後 `specify ...`        |
| 本地 uvx 執行 (repo 根目錄) | `uvx --from . specify ...`                      |
| 本地 uvx 執行 (絕對路徑)    | `uvx --from /mnt/c/GitHub/spec-kit specify ...` |
| Git 分支 uvx                | `uvx --from git+URL@branch specify ...`         |
| 建置 wheel                  | `uv build`                                      |

## 11. 清理

快速移除建置產物 / 虛擬環境：
```bash
rm -rf .venv dist build *.egg-info
```

## 12. 常見問題

| 症狀                         | 修復方法                                 |
| ---------------------------- | ---------------------------------------- |
| `ModuleNotFoundError: typer` | 執行 `uv pip install -e .`               |
| 指令碼不可執行 (Linux)       | 重新執行 init 或 `chmod +x scripts/*.sh` |
| Git 步驟被略過               | 您傳遞了 `--no-git` 或未安裝 Git         |
| 下載了錯誤的指令碼類型       | 明確傳遞 `--script sh` 或 `--script ps`  |
| 公司網路上的 TLS 錯誤        | 嘗試 `--skip-tls` (不適用於生產環境)     |

## 13. 後續步驟

- 更新文件並使用您修改過的 CLI 執行快速入門指南
- 滿意後開啟一個 PR
- (可選) 變更合併到 `main` 後標記一個版本


````

