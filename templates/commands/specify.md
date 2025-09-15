---
description: 從自然語言的功能描述中建立或更新功能規格。
scripts:
  sh: scripts/bash/create-new-feature.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-feature.ps1 -Json "{ARGS}"
---

根據作為引數提供的功能描述，執行以下操作：

1. 從儲存庫根目錄執行腳本 `{SCRIPT}` 並解析其 JSON 輸出以取得 BRANCH_NAME 和 SPEC_FILE。所有檔案路徑必須是絕對路徑。
2. 載入 `templates/spec-template.md` 以了解必要的章節。
3. 使用範本結構將規格寫入 SPEC_FILE，將佔位符替換為從功能描述（引數）衍生的具體細節，同時保留章節順序和標題。
4. 報告完成情況，包含分支名稱、規格檔案路徑，並準備好進入下一階段。

注意：此腳本在寫入之前會建立並切換到新分支，並初始化規格檔案。
