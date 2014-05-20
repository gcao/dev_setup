#!/bin/sh
function usage(){
  cat <<EOF
Usage: $0 <integer> <command>
 
Repeat <command> <integer> number of time
EOF
}
 
if [ -z $1 ] || ! [[ "$1" =~ ^[0-9]+$ ]]
then
  usage
  exit 1
fi
 
i=0
num=$1
shift
while [ $(( i += 1 )) -le $num ]; do
  eval "$@"
done
