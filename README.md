# ApprovalTests in the Shell

**Note:** only tested with bash.

![CI](https://github.com/kudashevs/ApprovalTests.shell/actions/workflows/ci.yml/badge.svg)


This is a small [Approval-Tests](http://approvaltests.com/) utility for the CLI Approval testing.  
It was forked from the [ApprovalTests.shell](https://github.com/approvals/ApprovalTests.shell). My credits to the authors.


## Usage

Given a command `<command>` that produces some output to verify. Use the `verify.sh` script on its output:
```bash
<command> | ./verify.sh -t <test-name> [-d <diff-tool>]
```

When you run it for the first time, the utility creates `<test-name>.received` and `<test-name>.approved` files. If the `<command>` has produced the axpected output, copy the content of the received file to the approved file. Then, run the the above sequence once again. The test should be green.

When the result of `<command>` changes in the future during the development, the existing test brakes and becomes red, and the `<diff-tool>` command will be triggered on a new output.


### Examples

A simplest example:
```bash
echo "hello world!" | ./verify.sh -t hello-world
```

Specify a different diff tool:
```bash
echo "hello diff tool" | ./verify.sh -t hello-diff -d "code --diff"
```


### Self-Test

Yes, the `verify.sh` is used to test itself:
```bash
(cd example && ./test.sh | ../verify.sh -t verify-cli-bash)
```

