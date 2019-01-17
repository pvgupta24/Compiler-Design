#!/bin/bash

DIRECTORY='outputs/'

if [ -d "$DIRECTORY" ]; then
    echo "Removing $DIRECTORY" 
    rm -rf "$DIRECTORY"
fi
mkdir "$DIRECTORY"

./run.sh

for testcase in $(ls testcases); do
    OUTPUT_FILE="$DIRECTORY$testcase.txt"
    ./scanner.out < testcases/$testcase > $OUTPUT_FILE | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"
done