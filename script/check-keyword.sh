# Pre commit hooks to keyword intercept the list of files in the staging area
# Add unwanted code to FILTER_WORDS if necessary

# 预先提交钩子，对暂存区中的文件列表进行关键字拦截
# 必要时将不需要的代码添加到 FILTER_WORDS 中

#!/bin/bash

# 设置需要过滤的关键字(支持中文)
FILTER_WORDS="测试 debugger"

# 设置不需要检测的目录或文件路径
IGNORE_PATHS=".git node_modules script src/App.vue README.md README-zh_CN.md"

# 获取暂存区中的文件列表
FILES=$(git diff --name-only --cached)

# 定义不需要检测的目录或文件路径
exclude_paths=(
  "node_modules/"
  "script/"
  "src/App.vue"
  "README.md"
  "README-zh_CN.md"
)

# 获取所有已暂存的文件的文件名列表
files=$(git diff --name-only --cached)

# 定义是否发现错误标志
has_error=false

# 遍历所有文件
for file in $files; do
  # 判断文件是否在排除路径中
  is_excluded=false
  for exclude_path in "${exclude_paths[@]}"; do
    if [[ $file == *"$exclude_path"* ]]; then
      is_excluded=true
      break
    fi
  done

  # 如果文件不在排除路径中，检查是否包含 "console debugger TODO" 关键字
  if ! $is_excluded; then
    if grep -q "console debugger TODO" $file; then
      echo -e "\033[1;31mFound 'console debugger TODO' in file: $file\033[0m"
      has_error=true
    fi
  fi
done

# 如果发现错误，退出并返回非零值
if $has_error; then
  echo -e "\033[1;31mError: Found 'console debugger TODO' in some files.\033[0m"
  exit 1
fi
