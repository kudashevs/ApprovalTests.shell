#!/bin/bash

GREEN_BG="\033[42m\033[30m"
RED_BG="\033[41m\033[37m"
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"
CHECK="\u2713"
CROSS="\u2715"

default_diff_tool="git diff --no-index"
diff_tool=$default_diff_tool

while getopts ":r:t:d:" opt; do
    case $opt in
    d) diff_tool=$OPTARG ;;
    r) received_text=$OPTARG ;;
    t) test_name=$OPTARG ;;
    \?) echo "Invalid option: -$OPTARG" >&2 ;;
    esac
done

received="$test_name.received"
approved="$test_name.approved"

if [ "$received_text" == "" ]; then
    cat - >"$received"
else
    echo "$received_text" >"$received"
fi

touch "$approved"

diff -q "$received" "$approved" >/dev/null &&
    (
        if [ -t 1 ]; then
            echo -e "${GREEN} ${CHECK} ${GREEN_BG} pass ${RESET} ${test_name} passed"
        else
            echo "${test_name} passed"
        fi
        rm "$received"
        echo ""
        true
    ) ||
    (
        if [ -t 1 ]; then
            echo -e "${RED} ${CROSS} ${RED_BG} fail ${RESET} ${test_name} failed"
            echo ""
            $diff_tool "$received" "$approved" --color=always </dev/tty | sed 's/^/    /'
        else
            echo "test failed"
            echo ""
            $diff_tool "$received" "$approved" | sed 's/^/    /'
        fi
        echo ""
        false
    )

