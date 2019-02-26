#!/usr/bin/env bash
# arg1=escaped,arg2=escaper1,....

# 被escape文字列, escape文字1,...
#TODO スクリプトにしよう
string=$1
pattern='\@'
declare -a list=("$@")
for((i = 1; i < ${#list[@]}; i ++))
do
  pattern=$pattern"|\\${list[$i]}"
done
# (escape文字|...)
pattern="($pattern)"
# escapeを行う
echo $string | perl -p -e 's;([^\\])'$pattern';\1\\\2;g'
