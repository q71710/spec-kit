#!/usr/bin/env bash
# 這個腳本的目的：
# 用於獲取當前功能分支的相關路徑資訊。
# 它會檢查功能分支名稱是否有效，
# 並輸出專案根目錄、功能目錄與相關文件的路徑。

set -e

# 獲取當前腳本所在的目錄
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 載入共用函數與變數
source "$SCRIPT_DIR/common.sh"

# 執行 get_feature_paths 函數，並將結果設定為環境變數
eval $(get_feature_paths)

# 檢查當前分支是否為有效的功能分支
check_feature_branch "$CURRENT_BRANCH" || exit 1

# 輸出相關路徑資訊
echo "REPO_ROOT: $REPO_ROOT"; \
     echo "BRANCH: $CURRENT_BRANCH"; \
     echo "FEATURE_DIR: $FEATURE_DIR"; \
     echo "FEATURE_SPEC: $FEATURE_SPEC"; \
     echo "IMPL_PLAN: $IMPL_PLAN"; \
     echo "TASKS: $TASKS"
