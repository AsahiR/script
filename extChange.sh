#!/usr/bin/env bash
# arg1=src_dir,arg1=beforeExtension,arg3=afterExtenstion
src=$1
before=$2
after=$3
find $src -name *.$before |
grep -e '.*\.' -o |
xargs -n1 -I@ cp @$before @$after
#echoをconvertにしてpng=>epsへ変換
