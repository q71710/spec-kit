#!/usr/bin/env bash
# 這個腳本的目的：
# 用於檢查功能分支的前置條件是否滿足。
# 它會驗證功能目錄與計畫文件是否存在，
# 並根據需要輸出相關的檔案資訊。

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

# 驗證功能目錄是否存在
if [[ ! -d "$FEATURE_DIR" ]]; then 
  echo "ERROR: Feature directory not found: $FEATURE_DIR"; 
  echo "Run /specify first."; 
  exit 1; 
fi

# 驗證計畫文件是否存在
if [[ ! -f "$IMPL_PLAN" ]]; then 
  echo "ERROR: plan.md not found in $FEATURE_DIR"; 
  echo "Run /plan first."; 
  exit 1; 
fi

# 如果啟用了 JSON 模式，輸出 JSON 格式的結果
if $JSON_MODE; then
  docs=(); 
  [[ -f "$RESEARCH" ]] && docs+=("research.md"); 
  [[ -f "$DATA_MODEL" ]] && docs+=("data-model.md"); 
  ([[ -d "$CONTRACTS_DIR" ]] && [[ -n "$(ls -A \"$CONTRACTS_DIR\" 2>/dev/null)" ]]) && docs+=("contracts/"); 
  [[ -f "$QUICKSTART" ]] && docs+=("quickstart.md");
  json_docs=$(printf '"%s",' "${docs[@]}"); 
  json_docs="[${json_docs%,}]"; 
  printf '{"FEATURE_DIR":"%s","AVAILABLE_DOCS":%s}\n' "$FEATURE_DIR" "$json_docs"
else
  # 否則以人類可讀的格式輸出結果
  echo "FEATURE_DIR:$FEATURE_DIR"; 
  echo "AVAILABLE_DOCS:"; 
  check_file "$RESEARCH" "research.md"; 
  check_file "$DATA_MODEL" "data-model.md"; 
  check_dir "$CONTRACTS_DIR" "contracts/"; 
  check_file "$QUICKSTART" "quickstart.md"; 
fi
