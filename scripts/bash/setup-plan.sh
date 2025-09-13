#!/usr/bin/env bash
# 這個腳本的目的：
# 用於設置功能分支的實作計畫環境。
# 它會檢查當前分支名稱是否符合功能分支的命名規範，
# 並根據模板生成對應的實作計畫文件，
# 最後輸出相關的環境變數資訊。

# 設定腳本在遇到錯誤時立即退出
set -e

# 預設 JSON_MODE 為 false
JSON_MODE=false

# 解析腳本參數
for arg in "$@"; do 
  case "$arg" in 
    --json) 
      # 如果參數為 --json，啟用 JSON 模式
      JSON_MODE=true 
      ;; 
    --help|-h) 
      # 如果參數為 --help 或 -h，顯示使用說明並退出
      echo "Usage: $0 [--json]"; exit 0 
      ;; 
  esac; 
done

# 獲取當前腳本所在的目錄
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 載入共用函數與變數
source "$SCRIPT_DIR/common.sh"

# 執行 get_feature_paths 函數，並將結果設定為環境變數
eval $(get_feature_paths)

# 檢查當前分支是否為有效的功能分支
check_feature_branch "$CURRENT_BRANCH" || exit 1

# 建立功能目錄（如果不存在）
mkdir -p "$FEATURE_DIR"

# 設定模板文件的路徑
TEMPLATE="$REPO_ROOT/.specify/templates/plan-template.md"

# 如果模板文件存在，將其複製到實作計畫路徑
[[ -f "$TEMPLATE" ]] && cp "$TEMPLATE" "$IMPL_PLAN"

# 如果啟用了 JSON 模式，輸出 JSON 格式的結果
if $JSON_MODE; then
  printf '{"FEATURE_SPEC":"%s","IMPL_PLAN":"%s","SPECS_DIR":"%s","BRANCH":"%s"}\n' \
    "$FEATURE_SPEC" "$IMPL_PLAN" "$FEATURE_DIR" "$CURRENT_BRANCH"
else
  # 否則以人類可讀的格式輸出結果
  echo "FEATURE_SPEC: $FEATURE_SPEC"; echo "IMPL_PLAN: $IMPL_PLAN"; echo "SPECS_DIR: $FEATURE_DIR"; echo "BRANCH: $CURRENT_BRANCH"
fi
