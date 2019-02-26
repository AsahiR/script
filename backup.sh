#!/usr/bin/env bash
# arg1=src,arg2=dst_dir
# dst_dir下にsrc_count.bakでbackupをとる
src=$1
dstDir=$2
file=$(basename $src)
limit=5
mkdir -p $dstDir
count=$(find $dstDir -name ${file}*.bak | grep  . -c)
#現在のbackup数
function makeBakupPath() {
  # backup用のpath生成
  base=$1
  index=$2
  echo ${base}_${index}".bak"
}

dstBase=${dstDir}'/'$file

if [ $count -ge $limit ]; then
  #TODO.limitは2以上
  for old in $(seq 2 $count);
  do
    # 一番古いbackupを削除して詰める
    new=$((old-1))
    mv $(makeBakupPath $dstBase $old) $(makeBakupPath $dstBase $new)
  done
else
  cp $src $(makeBakupPath $dstBase $((count+1)))
fi
