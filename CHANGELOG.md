## Release 1.0.8

559c25f [bugfix] need to restart after applying the patch (#41)
3ac3f8f add unit test to make sure log file is not truncated
fe83935 [bugfix] append to log file, not truncate it

## Release 1.0.7

* 34e05fe [bugfix] make role soft-depend on apt, and redhat-repo (#38)
* e67e851 [bugfix] QA (#37)
* 16fc2ec [bugfix] fix failure in creating node without labels (fixes #34)

## Release 1.0.6

* 71e12f4 QA
* 1ecd793 fix comment; TODO, not XXX
* 47d2231 fix README
* 62732e6 QA
* b353fb5 use git-client for FreeBSD; workaround for #31
* 91085e9 [bugfix] add labels (fixes #28)
* a147741 add id field to the xml (fixes #30)
* 9eefb89 [bugfix] add no_proxy (fixes #29)
* 7e0b2b5 QA

## Release 1.0.5

* 8c3f96f [bugfix] do not log passphrase given to openssl
* c22fce1 [bugfix] do not log password given to jenkins cli

## Release 1.0.4

* 68b4390 [bugfix] fix failures in ansible-playbook -CD
* 243be03 [bugfix] respect jenkins_master_port and jenkins_master_home in FreeBSD
* 8fbc4dd Revert "a workaround to solve the schema version issue"
* 52ed765 register ssh public key without temporary file

## Release 1.0.3

* e503b8a [bugfix] fix empty credential id
* 0bde6b3 a workaround to solve the schema version issue

## Release 1.0.2

* 603edf5 add explanation of `jenkins_master_nodes`
* c1fa1ee [bugfix] create nodes
* 425872c add tests for credential
* 9c2d065 [bugfix] register/update credential which is required to manage nodes

## Release 1.0.1

* b748536 [bugfix] create ssh key of jenkins user (#12)

## Release 1.0.0

* Initial release
