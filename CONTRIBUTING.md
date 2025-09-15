## 為 Spec Kit 做出貢獻

嗨！我們很高興您願意為 Spec Kit 做出貢G獻。此專案的貢獻將根據[專案的開源授權](LICENSE)向大眾[發布](https://help.github.com/articles/github-terms-of-service/#6-contributions-under-repository-license)。

請注意，此專案附帶一份[貢獻者行為準則](CODE_OF_CONDUCT.md)。參與此專案即表示您同意遵守其條款。

## 執行與測試程式碼的先決條件

這些是一次性安裝，以便您在提交拉取請求 (PR) 過程中能夠在本地測試您的變更。

1. 安裝 [Python 3.11+](https://www.python.org/downloads/)
2. 安裝 [uv](https://docs.astral.sh/uv/) 以進行套件管理
3. 安裝 [Git](https://git-scm.com/downloads)
4. 準備一個 AI 編碼助理：建議使用 [Claude Code](https://www.anthropic.com/claude-code)、[GitHub Copilot](https://code.visualstudio.com/) 或 [Gemini CLI](https://github.com/google-gemini/gemini-cli)，但我們也正在努力增加對其他助理的支援。

## 提交拉取請求

>[!NOTE]
>如果您的拉取請求引入了重大變更，對 CLI 或儲存庫的其他部分產生實質性影響（例如，您正在引入新的範本、參數或其他主要變更），請確保已與專案維護者**討論並達成共識**。未經事先溝通和同意的重大變更拉取請求將被關閉。

1. Fork 並複製儲存庫
2. 設定並安裝依賴項：`uv sync`
3. 確保 CLI 在您的機器上可以運作：`uv run specify --help`
4. 建立一個新分支：`git checkout -b my-branch-name`
5. 進行您的變更、新增測試，並確保一切仍然正常運作
6. 如果相關，請使用範例專案測試 CLI 功能
7. 推送到您的 fork 並提交拉取請求
8. 等待您的拉取請求被審查和合併。

以下是一些可以增加您的拉取請求被接受可能性的事項：

- 遵循專案的編碼慣例。
- 為新功能撰寫測試。
- 如果您的變更影響到使用者面向的功能，請更新文件（`README.md`、`spec-driven.md`）。
- 盡可能讓您的變更保持專注。如果您想進行多個互不依賴的變更，請考慮將它們作為單獨的拉取請求提交。
- 撰寫一則[好的提交訊息](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)。
- 使用規格驅動開發工作流程測試您的變更，以確保相容性。

## 開發工作流程

在開發 spec-kit 時：

1. 在您選擇的編碼助理中使用 `specify` CLI 命令（`/specify`、`/plan`、`/tasks`）測試變更
2. 驗證 `templates/` 目錄中的範本是否正常運作
3. 測試 `scripts/` 目錄中的腳本功能
4. 如果進行了重大的流程變更，請確保更新記憶體檔案（`memory/constitution.md`）

## 資源

- [規格驅動開發方法論](./spec-driven.md)
- [如何為開源做出貢獻](https://opensource.guide/how-to-contribute/)
- [使用拉取請求](https://help.github.com/articles/about-pull-requests/)
- [GitHub 說明](https://help.github.com)
