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
