```markdown
---
description: 根據使用者需求為當前功能生成自訂檢查清單。
scripts:
  sh: scripts/bash/check-prerequisites.sh --json
  ps: scripts/powershell/check-prerequisites.ps1 -Json
---

## 檢查清單目的：「英文的單元測試」

**核心概念**：檢查清單是**需求撰寫的單元測試** - 它們驗證特定領域中需求的品質、清晰度和完整性。

**不是用於驗證/測試**：
- ❌ 不是「驗證按鈕點擊是否正確」
- ❌ 不是「測試錯誤處理是否正常運作」
- ❌ 不是「確認 API 是否回傳 200」
- ❌ 不是檢查程式碼/實作是否符合規格

**用於需求品質驗證**：
- ✅ 「是否為所有卡片類型定義了視覺層次需求？」（完整性）
- ✅ 「『顯眼顯示』是否以特定的大小/位置進行量化？」（清晰度）
- ✅ 「懸停狀態需求在所有互動元素中是否一致？」（一致性）
- ✅ 「是否為鍵盤導航定義了無障礙需求？」（覆蓋範圍）
- ✅ 「規格是否定義了徽標圖片載入失敗時的處理方式？」（邊緣情況）

**比喻**：如果您的規格是用英文編寫的程式碼，則檢查清單就是其單元測試套件。您正在測試需求是否撰寫良好、完整、明確且準備實作——而不是測試實作是否有效。

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Execution Steps

1. **Setup**: Run `{SCRIPT}` from repo root and parse JSON for FEATURE_DIR and AVAILABLE_DOCS list.
   - All file paths must be absolute.

2. **澄清意圖（動態）**：推導最多三個初始內容澄清問題（無預設目錄）。它們必須：
   - 從使用者的措辭 + 從規格/計畫/任務中提取的信號生成
   - 只詢問會實質性地改變檢查清單內容的資訊
   - 如果在 `$ARGUMENTS` 中已經明確，則個別跳過
   - 偏好精確性而非廣度

   生成演算法：
   1. 提取信號：功能領域關鍵詞（例如：認證、延遲、UX、API）、風險指標（「關鍵」、「必須」、「合規」）、利害關係人提示（「QA」、「審查」、「安全團隊」）以及明確交付成果（「a11y」、「回滾」、「合約」）。
   2. 將信號聚集成候選焦點區域（最多 4 個），按相關性排序。
   3. 識別可能的受眾和時機（作者、審查者、QA、發布）如果不明確。
   4. 檢測遺失維度：範圍廣度、深度/嚴格性、風險強調、排除邊界、可測量驗收標準。
   5. 從這些原型中選擇問題：
      - 範圍細化（例如：「這應該包括與 X 和 Y 的整合觸點還是僅限於本地模組正確性？」）
      - 風險優先順序（例如：「這些潛在風險區域中哪些應該接受強制性關卡檢查？」）
      - 深度校準（例如：「這是輕量級的提交前合理性清單還是正式的發布關卡？」）
      - 受眾框定（例如：「這只會被作者使用還是在 PR 審查期間由同儕使用？」）
      - 邊界排除（例如：「我們應該明確排除這輪的效能調整項目嗎？」）
      - 情境類別差距（例如：「未檢測到復原流程——回滾/部分失敗路徑在範圍內嗎？」）

   問題格式規則：
   - 如果呈現選項，生成包含欄位的緊湊表格：選項 | 候選 | 為何重要
   - 最多限制 A-E 選項；如果自由形式答案更清楚則省略表格
   - 絕不要求使用者重述他們已經說過的話
   - 避免推測性類別（無幻覺）。如果不確定，明確詢問：「確認 X 是否屬於範圍。」

   無法互動時的預設值：
   - 深度：標準
   - 受眾：如果與程式碼相關則為審查者（PR）；否則為作者
   - 焦點：前 2 個相關性聚集

   輸出問題（標記 Q1/Q2/Q3）。答案後：如果 ≥2 個情境類別（替代/例外/復原/非功能領域）仍不清楚，您可以詢問最多兩個更有針對性的後續問題（Q4/Q5），每個都有一行理由（例如：「未解決的復原路徑風險」）。不要超過總共五個問題。如果使用者明確拒絕更多，跳過升級。

3. **理解使用者請求**：結合 `$ARGUMENTS` + 澄清答案：
   - 推導檢查清單主題（例如：安全性、審查、部署、使用者體驗）
   - 整合使用者提到的明確必備項目
   - 將焦點選擇對應到類別結構
   - 從規格/計畫/任務推斷任何遺失的內容（不要幻想）

4. **載入功能內容**：從 FEATURE_DIR 讀取：
   - spec.md：功能需求和範圍
   - plan.md（如果存在）：技術細節、依賴關係
   - tasks.md（如果存在）：實作任務
   
   **內容載入策略**：
   - 只載入與活動焦點區域相關的必要部分（避免全檔案傾印）
   - 偏好將長區段摘要為簡潔的情境/需求項目符號
   - 使用漸進披露：只有在檢測到差距時才添加後續檢索
   - 如果來源文件很大，生成中期摘要項目而不是嵌入原始文字

5. **生成檢查清單** - 建立「需求的單元測試」：
   - 如果不存在，建立 `FEATURE_DIR/checklists/` 目錄
   - 生成唯一的檢查清單檔案名稱：
     - 使用基於領域的簡短描述性名稱（例如：`ux.md`、`api.md`、`security.md`）
     - 格式：`[領域].md` 
     - 如果檔案存在，附加到現有檔案
   - 從 CHK001 開始循序編號項目
   - 每次 `/speckit.checklist` 執行都會建立新檔案（絕不覆寫現有檢查清單）

   **核心原則 - 測試需求，而非實作**：
   每個檢查清單項目必須評估需求本身的：
   - **完整性**：是否存在所有必要需求？
   - **清晰度**：需求是否明確且具體？
   - **一致性**：需求是否彼此一致？
   - **可測量性**：需求是否可以客觀驗證？
   - **覆蓋範圍**：是否涵蓋所有情境/邊緣情況？
   
   **類別結構** - 按需求品質維度分組項目：
   - **需求完整性**（是否記錄了所有必要需求？）
   - **需求清晰度**（需求是否具體且明確？）
   - **需求一致性**（需求是否沒有衝突地一致？）
   - **驗收標準品質**（成功標準是否可測量？）
   - **情境覆蓋**（是否涵蓋所有流程/情況？）
   - **邊緣情況覆蓋**（是否定義了邊界條件？）
   - **非功能性需求**（效能、安全性、無障礙等 - 是否已指定？）
   - **依賴關係與假設**（是否已記錄並驗證？）
   - **歧義與衝突**（需要澄清什麼？）
   
   **如何撰寫檢查清單項目 - 「英文的單元測試」**：
   
   ❌ **錯誤**（測試實作）：
   - 「驗證登陸頁面顯示 3 個劇集卡片」
   - 「測試懸停狀態在桌面上是否有效」
   - 「確認徽標點擊導航到首頁」
   
   ✅ **正確**（測試需求品質）：
   - 「是否指定了精選劇集的確切數量和佈局？」[完整性]
   - 「『顯著顯示』是否以特定大小/位置量化？」[清晰度]
   - 「懸停狀態需求在所有互動元素中是否一致？」[一致性]
   - 「是否為所有互動使用者介面定義了鍵盤導航需求？」[覆蓋範圍]
   - 「當徽標圖片載入失敗時是否指定了回退行為？」[邊緣情況]
   - 「是否為非同步劇集資料定義了載入狀態？」[完整性]
   - 「規格是否為競爭的使用者介面元素定義了視覺層次？」[清晰度]
   
   **ITEM STRUCTURE**:
   每個項目應遵循此模式：
   - 詢問需求品質的問題格式
   - 專注於規格/計畫中已撰寫（或未撰寫）的內容
   - 在方括號中包含品質維度 [完整性/清晰度/一致性/等]
   - 檢查現有需求時參考規格區段 `[Spec §X.Y]`
   - 檢查遺失需求時使用 `[Gap]` 標記
   
   **按品質維度的範例**：
   
   完整性：
   - 「是否為所有 API 失敗模式定義了錯誤處理需求？[Gap]」
   - 「是否為所有互動元素指定了無障礙需求？[完整性]」
   - 「是否為響應式佈局定義了行動中斷點需求？[Gap]」
   
   清晰度：
   - 「『快速載入』是否以特定的時間閾值量化？[清晰度, Spec §NFR-2]」
   - 「是否明確定義了『相關劇集』選擇標準？[清晰度, Spec §FR-5]」
   - 「『顯著』是否以可測量的視覺屬性定義？[歧義, Spec §FR-4]」
   
   一致性：
   - 「導航需求在所有頁面中是否一致？[一致性, Spec §FR-10]」
   - 「卡片元件需求在登陸頁面和詳細頁面之間是否一致？[一致性]」
   
   覆蓋範圍：
   - 「是否為零狀態情境（無劇集）定義了需求？[覆蓋範圍, 邊緣情況]」
   - 「是否處理了並發使用者互動情境？[覆蓋範圍, Gap]」
   - 「是否為部分資料載入失敗指定了需求？[覆蓋範圍, 例外流程]」
   
   可測量性：
   - 「視覺層次需求是否可測量/可測試？[驗收標準, Spec §FR-1]」
   - 「『平衡的視覺重量』是否可以客觀驗證？[可測量性, Spec §FR-2]」

   **情境分類與覆蓋**（需求品質焦點）：
   - 檢查是否存在需求：主要、替代、例外/錯誤、復原、非功能情境
   - 對於每個情境類別，詢問：「[情境類型] 需求是否完整、清晰且一致？」
   - 如果情境類別遺失：「[情境類型] 需求是故意排除還是遺失？[Gap]」
   - 當狀態變異發生時包含韌性/回滾：「是否為遷移失敗定義了回滾需求？[Gap]」

   **可追溯性需求**：
   - 最低要求：≥80% 的項目必須包含至少一個可追溯性參考
   - 每個項目應參考：規格區段 `[Spec §X.Y]`，或使用標記：`[Gap]`、`[歧義]`、`[衝突]`、`[假設]`
   - If no ID system exists: "Is a requirement & acceptance criteria ID scheme established? [Traceability]"

   **Surface & Resolve Issues** (Requirements Quality Problems):
   Ask questions about the requirements themselves:
   - Ambiguities: "Is the term 'fast' quantified with specific metrics? [Ambiguity, Spec §NFR-1]"
   - Conflicts: "Do navigation requirements conflict between §FR-10 and §FR-10a? [Conflict]"
   - Assumptions: "Is the assumption of 'always available podcast API' validated? [Assumption]"
   - Dependencies: "Are external podcast API requirements documented? [Dependency, Gap]"
   - Missing definitions: "Is 'visual hierarchy' defined with measurable criteria? [Gap]"

   **Content Consolidation**:
   - Soft cap: If raw candidate items > 40, prioritize by risk/impact
   - Merge near-duplicates checking the same requirement aspect
   - If >5 low-impact edge cases, create one item: "Are edge cases X, Y, Z addressed in requirements? [Coverage]"

   **🚫 ABSOLUTELY PROHIBITED** - These make it an implementation test, not a requirements test:
   - ❌ Any item starting with "Verify", "Test", "Confirm", "Check" + implementation behavior
   - ❌ References to code execution, user actions, system behavior
   - ❌ "Displays correctly", "works properly", "functions as expected"
   - ❌ "Click", "navigate", "render", "load", "execute"
   - ❌ Test cases, test plans, QA procedures
   - ❌ Implementation details (frameworks, APIs, algorithms)
   
   **✅ REQUIRED PATTERNS** - These test requirements quality:
   - ✅ "Are [requirement type] defined/specified/documented for [scenario]?"
   - ✅ "Is [vague term] quantified/clarified with specific criteria?"
   - ✅ "Are requirements consistent between [section A] and [section B]?"
   - ✅ "Can [requirement] be objectively measured/verified?"
   - ✅ "Are [edge cases/scenarios] addressed in requirements?"
   - ✅ "Does the spec define [missing aspect]?"

6. **Structure Reference**: Generate the checklist following the canonical template in `templates/checklist-template.md` for title, meta section, category headings, and ID formatting. If template is unavailable, use: H1 title, purpose/created meta lines, `##` category sections containing `- [ ] CHK### <requirement item>` lines with globally incrementing IDs starting at CHK001.

7. **Report**: Output full path to created checklist, item count, and remind user that each run creates a new file. Summarize:
   - Focus areas selected
   - Depth level
   - Actor/timing
   - Any explicit user-specified must-have items incorporated

**Important**: Each `/speckit.checklist` command invocation creates a checklist file using short, descriptive names unless file already exists. This allows:

- Multiple checklists of different types (e.g., `ux.md`, `test.md`, `security.md`)
- Simple, memorable filenames that indicate checklist purpose
- Easy identification and navigation in the `checklists/` folder

為了避免混亂，使用描述性類型並在完成後清理過時的檢查清單。

## Example Checklist Types & Sample Items

**UX 需求品質：** `ux.md`

範例項目（測試需求，而非實作）：
- "Are visual hierarchy requirements defined with measurable criteria? [Clarity, Spec §FR-1]"
- "Is the number and positioning of UI elements explicitly specified? [Completeness, Spec §FR-1]"
- "Are interaction state requirements (hover, focus, active) consistently defined? [Consistency]"
- "Are accessibility requirements specified for all interactive elements? [Coverage, Gap]"
- "Is fallback behavior defined when images fail to load? [Edge Case, Gap]"
- "Can 'prominent display' be objectively measured? [Measurability, Spec §FR-4]"

**API 需求品質：** `api.md`

範例項目：
- "Are error response formats specified for all failure scenarios? [Completeness]"
- "Are rate limiting requirements quantified with specific thresholds? [Clarity]"
- "Are authentication requirements consistent across all endpoints? [Consistency]"
- "Are retry/timeout requirements defined for external dependencies? [Coverage, Gap]"
- "Is versioning strategy documented in requirements? [Gap]"

**效能需求品質：** `performance.md`

範例項目：
- "Are performance requirements quantified with specific metrics? [Clarity]"
- "Are performance targets defined for all critical user journeys? [Coverage]"
- 「是否指定了不同負載條件下的效能需求？[完整性]」
- 「效能需求是否可以客觀測量？[可測量性]」
- 「是否為高負載情境定義了降級需求？[邊緣情況, Gap]」

**安全需求品質：** `security.md`

範例項目：
- 「是否為所有受保護資源指定了認證需求？[覆蓋範圍]」
- 「是否為敏感資訊定義了資料保護需求？[完整性]」
- 「威脅模型是否已記錄且需求與其一致？[可追溯性]」
- 「安全需求是否與合規義務一致？[一致性]」
- 「是否定義了安全失敗/破壞回應需求？[Gap, 例外流程]」

## 反面範例：不應該做的事

**❌ 錯誤 - 這些測試實作，而非需求：**

```markdown
- [ ] CHK001 - 驗證登陸頁面顯示 3 個劇集卡片 [Spec §FR-001]
- [ ] CHK002 - 測試懸停狀態在桌面上正常運作 [Spec §FR-003]
- [ ] CHK003 - 確認徽標點擊導航到首頁 [Spec §FR-010]
- [ ] CHK004 - 檢查相關劇集區段顯示 3-5 個項目 [Spec §FR-005]
```

**✅ 正確 - 這些測試需求品質：**

```markdown
- [ ] CHK001 - 是否明確指定了精選劇集的數量和佈局？[完整性, Spec §FR-001]
- [ ] CHK002 - 是否為所有互動元素一致地定義了懸停狀態需求？[一致性, Spec §FR-003]
- [ ] CHK003 - 是否為所有可點擊的品牌元素清楚地定義了導航需求？[清晰度, Spec §FR-010]
- [ ] CHK004 - 是否記錄了相關劇集的選擇標準？[Gap, Spec §FR-005]
- [ ] CHK005 - 是否為非同步劇集資料定義了載入狀態需求？[Gap]
- [ ] CHK006 - 「視覺層次」需求是否可以客觀測量？[可測量性, Spec §FR-001]
```

**關鍵差異：**
- 錯誤：測試系統是否正確運作
- 正確：測試需求是否正確撰寫
- 錯誤：行為的驗證
- 正確：需求品質的驗證
- 錯誤：「它是否執行 X？」
- 正確：「X 是否清楚地指定？」
