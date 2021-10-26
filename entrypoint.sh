#!/bin/bash

cwd=$(pwd)

# initialize license
cd /usr/local/stata
export PATH=/usr/local/stata:$PATH
./stinit << EOF
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
cat ${basefile}.log

# Fail CI if Stata ran with an error
EXIT_CODE=$(tail -1 ${basefile}.log | tr -d '[:cntrl:]')

if [[ ${EXIT_CODE:0:1} == "r" ]]; then
    exit 1
fi
