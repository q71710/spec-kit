#!/usr/bin/env bash
# 這個腳本的目的：
# 用於創建新的功能分支，並生成對應的目錄結構與模板文件。
# 它會自動分配功能編號，建立分支與目錄，
# 並根據模板生成規範文件。

set -e

# 預設 JSON_MODE 為 false
JSON_MODE=false
ARGS=()

# 解析腳本參數
for arg in "$@"; do
    case "$arg" in
        --json) 
            # 如果參數為 --json，啟用 JSON 模式
            JSON_MODE=true 
            ;;
        --help|-h) 
            # 如果參數為 --help 或 -h，顯示使用說明並退出
            echo "Usage: $0 [--json] <feature_description>"; exit 0 
            ;;
        *) 
            # 收集其他參數作為功能描述
            ARGS+=("$arg") 
            ;;
    esac
done

# 獲取功能描述
FEATURE_DESCRIPTION="${ARGS[*]}"
if [ -z "$FEATURE_DESCRIPTION" ]; then
    echo "Usage: $0 [--json] <feature_description>" >&2
    exit 1
fi

# 獲取專案根目錄
REPO_ROOT=$(git rev-parse --show-toplevel)
# 設定規範目錄
SPECS_DIR="$REPO_ROOT/specs"
# 建立規範目錄（如果不存在）
mkdir -p "$SPECS_DIR"

# 找到當前最高的功能編號
HIGHEST=0
if [ -d "$SPECS_DIR" ]; then
    for dir in "$SPECS_DIR"/*; do
        [ -d "$dir" ] || continue
        dirname=$(basename "$dir")
        number=$(echo "$dirname" | grep -o '^[0-9]\+' || echo "0")
        number=$((10#$number))
        if [ "$number" -gt "$HIGHEST" ]; then HIGHEST=$number; fi
    done
fi

# 計算下一個功能編號
NEXT=$((HIGHEST + 1))
FEATURE_NUM=$(printf "%03d" "$NEXT")

# 根據功能描述生成分支名稱
BRANCH_NAME=$(echo "$FEATURE_DESCRIPTION" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/-\+/-/g' | sed 's/^-//' | sed 's/-$//')
WORDS=$(echo "$BRANCH_NAME" | tr '-' '\n' | grep -v '^$' | head -3 | tr '\n' '-' | sed 's/-$//')
BRANCH_NAME="${FEATURE_NUM}-${WORDS}"

# 創建新的 Git 分支
git checkout -b "$BRANCH_NAME"

# 設定功能目錄
FEATURE_DIR="$SPECS_DIR/$BRANCH_NAME"
# 建立功能目錄
mkdir -p "$FEATURE_DIR"

# 設定模板文件與規範文件路徑
TEMPLATE="$REPO_ROOT/templates/spec-template.md"
SPEC_FILE="$FEATURE_DIR/spec.md"
# 如果模板文件存在，複製到規範文件路徑；否則建立空白文件
if [ -f "$TEMPLATE" ]; then 
    cp "$TEMPLATE" "$SPEC_FILE"; 
else 
    touch "$SPEC_FILE"; 
fi

# 如果啟用了 JSON 模式，輸出 JSON 格式的結果
if $JSON_MODE; then
    printf '{"BRANCH_NAME":"%s","SPEC_FILE":"%s","FEATURE_NUM":"%s"}\n' "$BRANCH_NAME" "$SPEC_FILE" "$FEATURE_NUM"
else
    # 否則以人類可讀的格式輸出結果
    echo "BRANCH_NAME: $BRANCH_NAME"
    echo "SPEC_FILE: $SPEC_FILE"
    echo "FEATURE_NUM: $FEATURE_NUM"
fi
