#!/bin/bash

WORK_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

pushd ${WORK_DIR} >/dev/null || exit 1

echo "test: pass"
../verify.sh -t test1 <<< "test 1 approves this message
line 2"

echo "test: fails and triggers diff tool"
../verify.sh -t test3 -d diff <<< "test 3 receives this input"

popd >/dev/null

