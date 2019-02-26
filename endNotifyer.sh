#!/usr/bin/env bash
# arg1=username, arg2=mail.
# 権限の問題でusernameは全一致しているものとみなしていい
username=$1
email=$2
count=$(qstat | grep -e $username -c)
path=$0
#TODOフルパス
cronpath='./test/'$username
#commandline="r.asahi asahi.r.aa@m.titech.ac.jp"
#TODO コマンドはフルパス
commandline="$path $usernam $email"

function escape () {
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
}

function end_proc () {
  log='log'
  #コマンドがうまくいかないときに記録
  path=$1
  #crontabの設定ファイル
  key=$2
  #crontab上のtaskの主key
  # logファイルを新規
  echo '' > $log
  # 該当行をcrontabファイルから消す
  cp  $path ${path}.bak 2>>$log
  # perlコマンド用にエスケープをしておく
  escape_key=$(escape "$key" '@' '.' '/')
  echo $escape_key
  # keyから特定したタスクの行をcrontabファイルから削除
  command='print if !/.*'"$escape_key"'.*/'
  perl -i -ne "$command" "$path" 2>>$log
  # ログファイルのサイズを告知
  filesize=$(wc -c $log)
  echo "Job finished. $log size is ${filesize}."|
  mail $email
}
#echo $commandline

if [ $count -eq 0 ]; then
  end_proc "$cronpath" "$commandline"
  # backupをとる
fi
