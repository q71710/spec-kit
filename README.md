<div align="center">
    <img src="./media/logo_small.webp"/>
    <h1>🌱 Spec Kit</h1>
    <h3><em>更快地建構高品質軟體。</em></h3>
</div>

<p align="center">
    <strong>旨在透過規格驅動開發，讓組織專注於產品情境，而非撰寫無差異化的程式碼。</strong>
</p>

[![Release](https://github.com/github/spec-kit/actions/workflows/release.yml/badge.svg)](https://github.com/github/spec-kit/actions/workflows/release.yml)

---

## 目錄

- [🤔 什麼是規格驅動開發？](#-什麼是規格驅動開發)
- [⚡ 開始使用](#-開始使用)
- [🔧 Specify CLI 參考](#-specify-cli-參考)
- [📚 核心理念](#-核心理念)
- [🌟 開發階段](#-開發階段)
- [🎯 實驗目標](#-實驗目標)
- [🔧 先決條件](#-先決條件)
- [📖 了解更多](#-了解更多)
- [📋 詳細流程](#-詳細流程)
- [🔍 疑難排解](#-疑難排解)
- [👥 維護者](#-維護者)
- [💬 支援](#-支援)
- [🙏 致謝](#-致謝)
- [📄 授權](#-授權)

## 🤔 什麼是規格驅動開發？

規格驅動開發**顛覆了**傳統的軟體開發模式。數十年來，程式碼為王——規格只是我們在「真正」的編碼工作開始後就建立並拋棄的鷹架。規格驅動開發改變了這一點：**規格變得可執行**，直接產生可運作的實作，而不僅僅是指導它們。

## ⚡ 開始使用

### 1. 安裝 Specify

根據您使用的編碼代理初始化您的專案：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <專案名稱>
```

### 2. 建立規格

使用 **`/specify`** 命令來描述您想建立的內容。專注於**什麼**和**為什麼**，而不是技術堆疊。

```bash
/specify 建立一個應用程式，幫助我將照片整理到不同的相簿中。相簿按日期分組，並可在主頁上透過拖放重新整理。相簿不會嵌套在其他相簿中。在每個相簿內，照片以類似圖塊的介面預覽。
```

### 3. 建立技術實作計畫

使用 **`/plan`** 命令提供您的技術堆疊和架構選擇。

```bash
/plan 該應用程式使用 Vite，並盡可能減少函式庫的使用。盡可能使用原生的 HTML、CSS 和 JavaScript。圖片不會上傳到任何地方，元數據儲存在本地的 SQLite 資料庫中。
```

### 4. 分解並實作

使用 **`/tasks`** 建立一個可操作的任務列表，然後要求您的代理實作該功能。

有關詳細的逐步說明，請參閱我們的[綜合指南](./spec-driven.md)。

## 🔧 Specify CLI 參考

`specify` 命令支援以下選項：

### 命令

| 命令    | 描述                                                                                 |
| ------- | ------------------------------------------------------------------------------------ |
| `init`  | 從最新的範本初始化一個新的 Specify 專案                                              |
| `check` | 檢查已安裝的工具 (`git`, `claude`, `gemini`, `code`/`code-insiders`, `cursor-agent`) |

### `specify init` 參數與選項

| 參數/選項              | 類型 | 描述                                                        |
| ---------------------- | ---- | ----------------------------------------------------------- |
| `<專案名稱>`           | 參數 | 新專案目錄的名稱 (如果使用 `--here` 則為可選)               |
| `--ai`                 | 選項 | 要使用的 AI 助理：`claude`、`gemini`、`copilot` 或 `cursor` |
| `--script`             | 選項 | 要使用的腳本變體：`sh` (bash/zsh) 或 `ps` (PowerShell)      |
| `--ignore-agent-tools` | 旗標 | 跳過對 AI 代理工具（如 Claude Code）的檢查                  |
| `--no-git`             | 旗標 | 跳過 git 儲存庫初始化                                       |
| `--here`               | 旗標 | 在當前目錄中初始化專案，而不是建立一個新目錄                |
| `--skip-tls`           | 旗標 | 跳過 SSL/TLS 驗證 (不建議)                                  |
| `--debug`              | 旗標 | 啟用詳細的偵錯輸出以進行疑難排解                            |

### 範例

```bash
# 基本專案初始化
specify init my-project

# 使用特定的 AI 助理初始化
specify init my-project --ai claude

# 使用 Cursor 支援初始化
specify init my-project --ai cursor

# 使用 PowerShell 腳本初始化 (Windows/跨平台)
specify init my-project --ai copilot --script ps

# 在當前目錄中初始化
specify init --here --ai copilot

# 跳過 git 初始化
specify init my-project --ai gemini --no-git

# 啟用偵錯輸出以進行疑難排解
specify init my-project --ai claude --debug

# 檢查系統需求
specify check
```

## 📚 核心理念

規格驅動開發是一個結構化的流程，強調：

- **意圖驅動開發**，規格在「如何做」之前定義「做什麼」
- 使用護欄和組織原則**建立豐富的規格**
- **多步驟精煉**，而非從提示一次性生成程式碼
- **高度依賴**先進的 AI 模型能力來解釋規格

## 🌟 開發階段

| 階段                     | 重點         | 主要活動                                                                                              |
| ------------------------ | ------------ | ----------------------------------------------------------------------------------------------------- |
| **0 到 1 開發** ("綠地") | 從頭開始生成 | <ul><li>從高階需求開始</li><li>產生規格</li><li>規劃實作步驟</li><li>建構生產就緒的應用程式</li></ul> |
| **創意探索**             | 平行實作     | <ul><li>探索多樣化的解決方案</li><li>支援多種技術堆疊與架構</li><li>實驗 UX 模式</li></ul>            |
| **迭代增強** ("棕地")    | 棕地現代化   | <ul><li>迭代新增功能</li><li>現代化舊有系統</li><li>調整流程</li></ul>                                |

## 🎯 實驗目標

我們的研究與實驗專注於：

### 技術獨立性

- 使用多樣化的技術堆疊建立應用程式
- 驗證規格驅動開發是一個不與特定技術、程式語言或框架綁定的流程的假設

### 企業限制

- 展示關鍵任務應用程式的開發
- 整合組織限制 (雲端供應商、技術堆疊、工程實務)
- 支援企業設計系統與合規要求

### 以使用者為中心的開發

- 為不同的使用者群體與偏好建構應用程式
- 支援各種開發方法 (從氛圍編碼到 AI 原生開發)

### 創意與迭代流程

- 驗證平行實作探索的概念
- 提供穩健的迭代功能開發工作流程
- 擴展流程以處理升級與現代化任務

## 🔧 先決條件

- **Linux/macOS** (或 Windows 上的 WSL2)
- AI 編碼代理：[Claude Code](https://www.anthropic.com/claude-code)、[GitHub Copilot](https://code.visualstudio.com/)、[Gemini CLI](https://github.com/google-gemini/gemini-cli) 或 [Cursor](https://cursor.sh/)
- [uv](https://docs.astral.sh/uv/) 用於套件管理
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

## 📖 了解更多

- **[完整的規格驅動開發方法論](./spec-driven.md)** - 深入了解完整流程
- **[詳細演練](#-詳細流程)** - 逐步實作指南

---

## 📋 詳細流程

<details>
<summary>點擊展開詳細的逐步演練</summary>

您可以使用 Specify CLI 來引導您的專案，這將在您的環境中引入所需的產物。執行：

```bash
specify init <專案名稱>
```

或在當前目錄中初始化：

```bash
specify init --here
```

![Specify CLI 在終端機中引導一個新專案](./media/specify_cli.gif)

系統將提示您選擇正在使用的 AI 代理。您也可以直接在終端機中主動指定它：

```bash
specify init <專案名稱> --ai claude
specify init <專案名稱> --ai gemini
specify init <專案名稱> --ai copilot
# 或在當前目錄中：
specify init --here --ai claude
```

CLI 將檢查您是否已安裝 Claude Code 或 Gemini CLI。如果您沒有安裝，或者您希望在不檢查正確工具的情況下取得範本，請在您的命令中使用 `--ignore-agent-tools`：

```bash
specify init <專案名稱> --ai claude --ignore-agent-tools
```

### **步驟 1：** 引導專案

進入專案資料夾並執行您的 AI 代理。在我們的範例中，我們使用 `claude`。

![引導 Claude Code 環境](./media/bootstrap-claude-code.gif)

如果您看到 `/specify`、`/plan` 和 `/tasks` 命令可用，就表示設定正確。

第一步應該是建立一個新的專案鷹架。使用 `/specify` 命令，然後提供您想開發的專案的具體需求。

>[!IMPORTANT]
>盡可能明確地說明您想建立**什麼**以及**為什麼**。**此時不要專注於技術堆疊**。

一個範例提示：

```text
開發 Taskify，一個團隊生產力平台。它應該允許使用者建立專案、新增團隊成員、
指派任務、評論並以看板風格在板之間移動任務。在這個功能的初始階段，
我們稱之為「建立 Taskify」，讓我們有多個使用者，但使用者將是預先定義的。
我想要五個使用者，分為兩類，一個產品經理和四個工程師。讓我們建立三個
不同的範例專案。讓我們為每個任務的狀態設定標準的看板欄位，例如「待辦」、
「進行中」、「審核中」和「完成」。此應用程式將沒有登入功能，因為這只是
第一個測試，以確保我們的基本功能已設定好。對於任務卡片 UI 中的每個任務，
您應該能夠在看板工作板的不同欄位之間變更任務的當前狀態。
您應該能夠為特定卡片留下無限數量的評論。您應該能夠從該任務
卡片中指派一個有效的使用者。當您第一次啟動 Taskify 時，它會給您一個五個使用者的列表供您選擇
。不需要密碼。當您點擊一個使用者時，您會進入主視圖，其中顯示專案列表
。當您點擊一個專案時，您會打開該專案的看板。您會看到各個欄位。
您將能夠在不同欄位之間來回拖放卡片。您會看到任何分配給
您（當前登入的使用者）的卡片以與所有其他卡片不同的顏色顯示，以便您快速
看到您的卡片。您可以編輯您所做的任何評論，但不能編輯其他人所做的評論。您可以
刪除您所做的任何評論，但不能刪除其他人所做的任何評論。
```

輸入此提示後，您應該會看到 Claude Code 啟動規劃和規格草擬流程。Claude Code 也會觸發一些內建腳本來設定儲存庫。

此步驟完成後，您應該會建立一個新分支 (例如，`001-create-taskify`)，以及 `specs/001-create-taskify` 目錄中的一個新規格。

產生的規格應包含一組使用者故事和功能需求，如範本中所定義。

在此階段，您的專案資料夾內容應類似於以下內容：

```text
├── memory
│	 ├── constitution.md
│	 └── constitution_update_checklist.md
├── scripts
│	 ├── check-task-prerequisites.sh
│	 ├── common.sh
│	 ├── create-new-feature.sh
│	 ├── get-feature-paths.sh
│	 ├── setup-plan.sh
│	 └── update-claude-md.sh
├── specs
│	 └── 001-create-taskify
│	     └── spec.md
└── templates
    ├── plan-template.md
    ├── spec-template.md
    └── tasks-template.md
```

### **步驟 2：** 功能規格釐清

建立基準規格後，您可以繼續釐清第一次嘗試中未正確捕捉到的任何需求。例如，您可以在同一個 Claude Code 會話中使用如下提示：

```text
對於您建立的每個範例專案或專案，應該有 5 到 15 個任務，數量可變，
隨機分佈到不同的完成狀態。確保每個完成階段至少有
一個任務。
```

您還應該要求 Claude Code 驗證**審查與驗收檢查清單**，勾選已驗證/符合需求的項目，並將不符合的項目保留為未勾選。可以使用以下提示：

```text
閱讀審查與驗收檢查清單，如果功能規格符合標準，請勾選清單中的每個項目。如果不符合，則將其保留為空。
```

重要的是將與 Claude Code 的互動視為釐清和提問規格的機會——**不要將其第一次嘗試視為最終版本**。

### **步驟 3：** 產生計畫

您現在可以具體說明技術堆疊和其他技術需求。您可以使用專案範本中內建的 `/plan` 命令，並使用如下提示：

```text
我們將使用 .NET Aspire 來產生這個，並使用 Postgres 作為資料庫。前端應該使用
Blazor 伺服器，具有拖放任務板和即時更新功能。應該建立一個 REST API，包含專案 API、
任務 API 和通知 API。
```

此步驟的輸出將包含許多實作細節文件，您的目錄樹將類似於此：

```text
.
├── CLAUDE.md
├── memory
│	 ├── constitution.md
│	 └── constitution_update_checklist.md
├── scripts
│	 ├── check-task-prerequisites.sh
│	 ├── common.sh
│	 ├── create-new-feature.sh
│	 ├── get-feature-paths.sh
│	 ├── setup-plan.sh
│	 └── update-claude-md.sh
├── specs
│	 └── 001-create-taskify
│	     ├── contracts
│	     │	 ├── api-spec.json
│	     │	 └── signalr-spec.md
│	     ├── data-model.md
│	     ├── plan.md
│	     ├── quickstart.md
│	     ├── research.md
│	     └── spec.md
└── templates
    ├── CLAUDE-template.md
    ├── plan-template.md
    ├── spec-template.md
    └── tasks-template.md
```

檢查 `research.md` 文件，以確保根據您的指示使用了正確的技術堆疊。如果任何組件突出，您可以要求 Claude Code 對其進行精煉，甚至讓它檢查您想使用的平台/框架的本地安裝版本 (例如 .NET)。

此外，如果所選的技術堆疊是快速變化的 (例如 .NET Aspire、JS 框架)，您可能需要要求 Claude Code 研究有關其詳細資訊，提示如下：

```text
我希望您瀏覽實作計畫和實作細節，尋找可能
從額外研究中受益的領域，因為 .NET Aspire 是一個快速變化的函式庫。對於您識別出需要
進一步研究的那些領域，我希望您更新研究文件，提供有關我們將在此 Taskify 應用程式中使用的特定
版本的更多詳細資訊，並產生平行研究任務，以使用來自網路的研究來釐清
任何細節。
```

在此過程中，您可能會發現 Claude Code 卡在研究錯誤的事情上——您可以使用如下提示來引導它朝著正確的方向前進：

```text
我認為我們需要將其分解為一系列步驟。首先，識別出您在實作過程中
需要執行但不確定或會從
進一步研究中受益的任務列表。寫下這些任務的列表。然後對於這些任務中的每一個，
我希望您啟動一個單獨的研究任務，以便最終結果是我們正在
平行研究所有這些非常具體的任務。我看到您所做的是，看起來您正在
籠統地研究 .NET Aspire，我認為在這種情況下這對我們沒有太大幫助。
那是太沒有針對性的研究。研究需要幫助您解決一個具體的、有針對性的問題。
```

>[!NOTE]
>Claude Code 可能會過於熱心，並新增您未要求的組件。請要求它釐清其理由和變更的來源。

### **步驟 4：** 讓 Claude Code 驗證計畫

計畫就緒後，您應該讓 Claude Code 執行一遍，以確保沒有遺漏任何部分。您可以使用如下提示：

```text
現在我希望您去審核實作計畫和實作細節文件。
以確定是否存在從閱讀中可以明顯看出的您需要
執行的一系列任務的眼光來閱讀它。因為我不知道這裡是否有足夠的資訊。例如，
當我查看核心實作時，參考實作
細節中可以找到資訊的適當位置會很有用，因為它會逐步執行核心實作或精煉中的每個步驟。
```

這有助於精煉實作計畫，並幫助您避免 Claude Code 在其規劃週期中遺漏的潛在盲點。初始精煉通過後，在您可以開始實作之前，再次要求 Claude Code 檢查清單。

您還可以要求 Claude Code (如果您已安裝 [GitHub CLI](https://docs.github.com/en/github-cli/github-cli)) 繼續從您當前的分支建立一個到 `main` 的拉取請求，並附上詳細說明，以確保工作得到適當的追蹤。

>[!NOTE]
>在讓代理實作之前，還值得提示 Claude Code 交叉檢查細節，看看是否有任何過度設計的部分 (記住——它可能會過於熱心)。如果存在過度設計的組件或決策，您可以要求 Claude Code 解決它們。確保 Claude Code 遵循[章程](base/memory/constitution.md)作為其在建立計畫時必須遵守的基礎文件。

### 步驟 5：實作

準備就緒後，指示 Claude Code 實作您的解決方案 (包含範例路徑)：

```text
implement specs/002-create-taskify/plan.md
```

Claude Code 將立即行動，並開始建立實作。

>[!IMPORTANT]
>Claude Code 將執行本地 CLI 命令 (例如 `dotnet`)——確保您已在您的機器上安裝它們。

實作步驟完成後，要求 Claude Code 嘗試執行應用程式並解決任何出現的建置錯誤。如果應用程式可以執行，但存在 Claude Code 無法透過 CLI 日誌直接取得的**執行時錯誤** (例如，在瀏覽器日誌中呈現的錯誤)，請將錯誤複製並貼到 Claude Code 中，讓它嘗試解決。

</details>

---

## 🔍 疑難排解

### Linux 上的 Git 憑證管理器

如果您在 Linux 上遇到 Git 驗證問題，可以安裝 Git 憑證管理器：

```bash
#!/usr/bin/env bash
set -e
echo "正在下載 Git 憑證管理器 v2.6.1..."
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.deb
echo "正在安裝 Git 憑證管理器..."
sudo dpkg -i gcm-linux_amd64.2.6.1.deb
echo "正在設定 Git 以使用 GCM..."
git config --global credential.helper manager
echo "正在清理..."
rm gcm-linux_amd64.2.6.1.deb
```

## 👥 維護者

- Den Delimarsky ([@localden](https://github.com/localden))
- John Lam ([@jflam](https://github.com/jflam))

## 💬 支援

如需支援，請開啟一個 [GitHub Issue](https://github.com/github/spec-kit/issues/new)。我們歡迎錯誤報告、功能請求以及有關使用規格驅動開發的問題。

## 🙏 致謝

本專案深受 [John Lam](https://github.com/jflam) 的工作與研究的影響並以此為基礎。

## 📄 授權

本專案根據 MIT 開源授權的條款進行授權。請參閱 [LICENSE](./LICENSE) 檔案以取得完整條款。
