# ansible-role-jenkins-master

Installs and configures Jenkins master node.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `jenkins_master_user` | Jenkins user | `{{ __jenkins_master_user }}` |
| `jenkins_master_group` | Jenkins group | `{{ __jenkins_master_group }}` |
| `jenkins_master_service` | service name | `{{ __jenkins_master_service }}` |
| `jenkins_master_home` | Jenkins home | `{{ __jenkins_master_home }}` |
| `jenkins_master_package` | package name | `{{ __jenkins_master_package }}` |
| `jenkins_master_updates_dir` | path to updates dir | `{{ jenkins_master_home }}/updates` |
| `jenkins_master_java_opts` | `JAVA_OPTS` to pass Jenkins | `["-Djava.awt.headless=true", "-Djenkins.install.runSetupWizard=false"]` |
| `jenkins_master_jenkins_opts` | Jenkins options | `{{ __jenkins_master_jenkins_opts }}` |
| `jenkins_master_hostname` | hostname | `127.0.0.1` |
| `jenkins_master_port` | listen port | `{{ __jenkins_master_port }}` |
| `jenkins_master_url_prefix` | prefix of the URL | `{{ __jenkins_master_url_prefix }}` |
| `jenkins_master_url` | URL of Jenkins | `http://{{ jenkins_master_hostname }}:{{ jenkins_master_port }}{{ jenkins_master_url_prefix }}` |
| `jenkins_master_connection_retries` | | `60` |
| `jenkins_master_connection_delay` | | `5` |
| `jenkins_master_cli_path` | path to Jenkins CLI | `{{ __jenkins_master_cli_path }}` |
| `jenkins_master_admin_password_file` | | `""` |
| `jenkins_master_admin_user` | | `admin` |
| `jenkins_master_admin_password` | | `password` |
| `jenkins_master_plugins` | plugins to install | `[]` |
| `jenkins_master_ssh_passphrase` | passphrase of ssh key | `""` |
| `jenkins_master_ssh_private_key` | ssh private key | `""` |
| `jenkins_master_nodes` | slave nodes (see below) | `[]` |

## `jenkins_master_nodes`
array of dictionaries for slave nodes

| Key | Value | Mandatory |
|-|-|
| name | string to identify the node | yes |
| remotefs | home directory of jenkins user on the node | yes |
| host | FQDN or IP address | yes |
| labels | array of the label | no |

## Debian

| Variable | Default |
|----------|---------|
| `__jenkins_master_user` | `jenkins` |
| `__jenkins_master_group` | `jenkins` |
| `__jenkins_master_service` | `jenkins` |
| `__jenkins_master_home` | `/var/lib/jenkins` |
| `__jenkins_master_package` | `jenkins` |
| `__jenkins_master_cli_path` | `/usr/bin/jenkins-cli.jar` |
| `__jenkins_master_url_prefix` | `/` |
| `__jenkins_master_port` | `8080` |
| `__jenkins_master_jenkins_opts` | `""` |

## FreeBSD

| Variable | Default |
|----------|---------|
| `__jenkins_master_user` | `jenkins` |
| `__jenkins_master_group` | `jenkins` |
| `__jenkins_master_service` | `jenkins` |
| `__jenkins_master_home` | `/usr/local/jenkins` |
| `__jenkins_master_package` | `jenkins` |
| `__jenkins_master_cli_path` | `/usr/local/bin/jenkins-cli.jar` |
| `__jenkins_master_url_prefix` | `/jenkins` |
| `__jenkins_master_port` | `8180` |
| `__jenkins_master_jenkins_opts` | `--webroot={{ jenkins_master_home }}/war --httpPort={{ jenkins_master_port }}` |

## RedHat

| Variable | Default |
|----------|---------|
| `__jenkins_master_user` | `jenkins` |
| `__jenkins_master_group` | `jenkins` |
| `__jenkins_master_service` | `jenkins` |
| `__jenkins_master_home` | `/var/lib/jenkins` |
| `__jenkins_master_package` | `jenkins` |
| `__jenkins_master_cli_path` | `/usr/bin/jenkins-cli.jar` |
| `__jenkins_master_url_prefix` | `/` |
| `__jenkins_master_port` | `8080` |
| `__jenkins_master_jenkins_opts` | `""` |

# Dependencies

```yaml
dependencies:
  - { role: reallyenglish.java }
```

# Example Playbook

```yaml
- hosts: localhost
  roles:
    - role: reallyenglish.apt-repo
      when: ansible_os_family == "Debian"
    - role: reallyenglish.redhat-repo
      when: ansible_os_family == "RedHat"
    - role: reallyenglish.java
    - ansible-role-jenkins-master
  vars_files:
    - jenkins_master_ssh_private_key.yml
  vars:
    jenkins_master_url_prefix: /jenkins
    jenkins_master_plugins:
      - matrix-project
      - git
      - hipchat
      - ssh-slaves
    apt_repo_to_add:
      - ppa:webupd8team/java
    jenkins_master_ssh_passphrase: "passphrase"
    jenkins_master_nodes:
      - name: slave1
        remotefs: /usr/local/jenkins
        host: slave1.example.com
        labels:
          - label1
          - label2
      - name: slave2
        remotefs: /usr/local/jenkins
        host: 192.168.33.13
    jenkins_master_port: 8280
```

# License

```
Copyright (c) 2017 Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

This README was created by [qansible](https://github.com/trombik/qansible)
