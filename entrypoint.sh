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
basefile=${file%*.do}

# run do-file
stata-mp -b do $basefile

# print log result


if [[ -f ${basefile.log} ]]
then
   cat ${basefile}.log

   # Fail CI if Stata ran with an error
   LOG_CODE=$(tail -1 ${basefile}.log | tr -d '[:cntrl:]')
   [[ ${LOG_CODE:0:1} == "r" ]] && EXIT_CODE=1 
else
   EXIT_CODE=2
fi
exit $EXIT_CODE
