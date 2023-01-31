# Pre commit hook that prevents FORBIDDEN code from being commited.
# Add unwanted code to the FORBIDDEN array as necessary

#!/bin/bash

# for FILE in $(git diff --name-only --cached); do
#   echo $FILE
#   # 忽略检查的文件
#   if [[ $FILE == *".sh"* ]]; then
#     continue
#   fi
#   # 匹配不能上传的关键字
#   grep 'TODO\|debugger\|alert(' $FILE 2>&1 >/dev/null
#   if [ $? -eq 0 ]; then
#     # 将错误输出
#     echo -e $FILE '文件中包含了TODO、debugger、alert其中一个关键字请删除后再提交'
#     exit 1
#   fi
# done
# exit

# git diff-index --check --name-status $against -- | cut -c3-

# chmod +x .git/hooks/pre-commit

# #!/bin/bash

# for FILE in $(git diff-index -p -M --name-status HEAD -- | cut -c3-); do
#   if [ "grep 'TODO' $FILE" ]; then
#     echo $FILE '存在关键字'
#     exit 1
#   fi
# done
# exit

# #!/bin/bash

# FILES_PATTERN='\.(vue|ts)(\..+)?$'
# FORBIDDEN=(微盛 debugger TODO)

# for i in "${FORBIDDEN[@]}"; do
#   git diff --cached --name-only |
#     grep -E $FILES_PATTERN |
#     GREP_COLOR='4;5;37;41' xargs grep --color --with-filename -n $i &&
#     echo 'COMMIT REJECTED Found' $i 'references. Please remove them before commiting' && exit 1
# done

# exit 0

# # 获取所有要提交的文件名称
# files=$(git diff --name-only --cached)

# # 定义过滤的关键字
# keywords="console debugger TODO"

# # 遍历每一个文件名称
# for file in $files; do
#   # 遍历每一个关键字
#   for keyword in $keywords; do
#     # 判断该文件中是否包含该关键字
#     if grep -q $keyword $file; then
#       echo "文件 $file 中存在关键字 $keyword"
#       exit 1
#     fi
#   done
# done

# echo "提交的文件中没有关键字，可以安全提交"
# exit 0

# 设置不需要过滤的目录
excluded_dirs=(
  "node_modules"
  "dist"
)

# 获取所有已缓存的改动文件
cached_files=$(git diff --name-only --cached)

# 对每个已缓存的改动文件进行遍历
for file in $cached_files; do

  # 跳过不需要过滤的目录
  skip=false
  for dir in "${excluded_dirs[@]}"; do
    if [[ $file == *"/$dir/"* ]]; then
      skip=true
      break
    fi
  done
  if $skip; then
    continue
  fi

  # 读取文件中的内容，并且搜索 "console debugger TODO" 关键字
  content=$(cat $file)
  if [[ $content == *"console"* ]] || [[ $content == *"debugger"* ]] || [[ $content == *"TODO"* ]]; then
    echo "Found 'console debugger TODO' keywords in file $file"
  fi
done

