#!/usr/bin/env bash
# 這個腳本的目的：
# 提供所有腳本共用的函數與變數。
# 包括獲取專案根目錄、當前分支名稱，
# 驗證功能分支名稱，以及生成功能相關的路徑資訊。

# 獲取專案的根目錄
get_repo_root() { git rev-parse --show-toplevel; }

# 獲取當前分支名稱
get_current_branch() { git rev-parse --abbrev-ref HEAD; }

# 驗證功能分支名稱是否符合命名規範
check_feature_branch() {
    local branch="$1"
    if [[ ! "$branch" =~ ^[0-9]{3}- ]]; then
        echo "ERROR: Not on a feature branch. Current branch: $branch" >&2
        echo "Feature branches should be named like: 001-feature-name" >&2
        return 1
    fi; return 0
}

# 獲取功能目錄的路徑
get_feature_dir() { echo "$1/specs/$2"; }

# 生成功能相關的路徑資訊
get_feature_paths() {
    local repo_root=$(get_repo_root)
    local current_branch=$(get_current_branch)
    local feature_dir=$(get_feature_dir "$repo_root" "$current_branch")
    cat <<EOF
REPO_ROOT='$repo_root'
CURRENT_BRANCH='$current_branch'
FEATURE_DIR='$feature_dir'
FEATURE_SPEC='$feature_dir/spec.md'
IMPL_PLAN='$feature_dir/plan.md'
TASKS='$feature_dir/tasks.md'
RESEARCH='$feature_dir/research.md'
DATA_MODEL='$feature_dir/data-model.md'
QUICKSTART='$feature_dir/quickstart.md'
CONTRACTS_DIR='$feature_dir/contracts'
EOF
}

# 檢查檔案是否存在
check_file() { [[ -f "$1" ]] && echo "  ✓ $2" || echo "  ✗ $2"; }

# 檢查目錄是否存在且非空
check_dir() { [[ -d "$1" && -n $(ls -A "$1" 2>/dev/null) ]] && echo "  ✓ $2" || echo "  ✗ $2"; }
