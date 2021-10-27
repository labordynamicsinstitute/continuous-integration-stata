#!/bin/bash

cwd=$(pwd)

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
logfile=${file%*.do}.log

# run do-file
echo "==============================================="
echo "Running $basefile in working directory $workdir"

(cd $workdir && stata-mp -b do $basefile)

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
exit $EXIT_CODE
