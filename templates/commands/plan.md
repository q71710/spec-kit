---
description: 使用計畫範本執行實作規劃工作流程以產生設計產物。
scripts:
  sh: scripts/bash/setup-plan.sh --json
  ps: scripts/powershell/setup-plan.ps1 -Json
---

根據作為引數提供的實作細節，執行以下操作：

1. 從儲存庫根目錄執行 `{SCRIPT}` 並解析 JSON 以取得 FEATURE_SPEC、IMPL_PLAN、SPECS_DIR、BRANCH。所有未來檔案路徑必須是絕對路徑。
2. 讀取並分析功能規格以了解：
   - 功能需求與使用者故事
   - 功能性與非功能性需求
   - 成功標準與驗收標準
   - 提及的任何技術限制或依賴關係

3. 閱讀位於 `/memory/constitution.md` 的章程以了解章程要求。

4. 執行實作計畫範本：
   - 載入 `/templates/plan-template.md` (已複製到 IMPL_PLAN 路徑)
   - 將輸入路徑設定為 FEATURE_SPEC
   - 執行執行流程 (主要) 功能的步驟 1-10
   - 該範本是獨立且可執行的
   - 遵循指定的錯誤處理與閘門檢查
   - 讓範本引導在 $SPECS_DIR 中產生以下產物：
     * 階段 0 產生 research.md
     * 階段 1 產生 data-model.md, contracts/, quickstart.md
     * 階段 2 產生 tasks.md
   - 將使用者從引數提供的細節整合到技術背景中：{ARGS}
   - 在完成每個階段時更新進度追蹤

5. 驗證執行是否完成：
   - 檢查進度追蹤是否顯示所有階段皆已完成
   - 確保所有必要的產物都已產生
   - 確認執行中沒有錯誤狀態

6. 報告結果，包含分支名稱、檔案路徑與產生的產物。

對所有檔案操作使用儲存庫根目錄的絕對路徑，以避免路徑問題。
