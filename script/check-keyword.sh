# #!/bin/bash

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

# #!/bin/sh

# for FILE in $(git diff-index -p -M --name-status HEAD -- | cut -c3-); do
#   if [ "grep 'TODO' $FILE" ]; then
#     echo $FILE '存在关键字'
#     exit 1
#   fi
# done
# exit

#!/bin/bash

# Pre commit hook that prevents FORBIDDEN code from being commited.
# Add unwanted code to the FORBIDDEN array as necessary

FILES_PATTERN='\.(vue|ts)(\..+)?$'
FORBIDDEN=(微盛 debugger TODO)

for i in "${FORBIDDEN[@]}"; do
  git diff --cached --name-only | grep ".js" | xargs sed 's/ //g' | grep "ha_mobile.debug=true" &&
    echo 'COMMIT REJECTED Found ha_mobile.debug=true references. Please remove them before commiting' && exit 1

  git diff --cached --name-only |
    grep -E $FILES_PATTERN |
    GREP_COLOR='4;5;37;41' xargs grep --color --with-filename -n $i &&
    echo 'COMMIT REJECTED Found' $i 'references. Please remove them before commiting' && exit 1
done

exit 0
