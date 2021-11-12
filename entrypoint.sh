#!/bin/bash

cwd=$(pwd)

# Validate inputs
if [[ $# -le 7 ]]; then
    echo "Not enough  parameters" >&2
    exit 2
fi
if [[ $# -ge 9 ]]; then
    echo "Too many parameters - ignoring extras" >&2
fi

[[ -z $8 ]] && changedir=yes || changedir=$8
case $changedir in
   yes|Yes|YES|TRUE)
   changedir=yes
   ;;
   no|NO|No|FALSE)
   changedir=no
   ;;
   *)
   echo "Changedir must be 'yes' or 'no'" >&2
   exit 2
esac

# initialize license
cd /usr/local/stata
export PATH=/usr/local/stata:$PATH
sudo ./stinit << EOF
y
y
$3
$4
$5
y
y
$6
$7
y
EOF

# back to the default working directory
cd $cwd
file=$1
basefile=$(basename $file)
workdir=$(dirname $file)
EXIT_CODE=0

if [[ "$changedir" == "yes" ]]
then
    logfile=${file%*.do}.log
    # run do-file
    echo "==============================================="
    echo "Running $basefile in working directory $workdir"
    
    (cd $workdir && stata-mp -b do $basefile)
fi
if [[ "$changedir" == "no" ]]
then
    logfile=${basefile%*.do}.log
    # run do-file
    echo "==============================================="
    echo "Running $file from $cwd"
    
    stata-mp -b do $file
fi
# print log result

if [[ -f $logfile ]]
then
   echo "===== $logfile ====="
   cat $logfile

   # Fail CI if Stata ran with an error
   LOG_CODE=$(tail -1 $logfile | tr -d '[:cntrl:]')
   echo "===== LOG CODE: $LOG_CODE ====="
   [[ ${LOG_CODE:0:1} == "r" ]] && EXIT_CODE=1 
else
   echo "$logfile not found"
   EXIT_CODE=2
fi
echo "==== Exiting with code $EXIT_CODE"
exit $EXIT_CODE
