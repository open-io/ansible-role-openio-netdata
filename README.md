[![Build Status](https://travis-ci.org/open-io/ansible-role-openio-netdata.svg?branch=master)](https://travis-ci.org/open-io/ansible-role-openio-netdata)
# Ansible role `netdata`

An Ansible role for install netdata. Specifically, the responsibilities of this role are to:

- install and configure netdata

## Requirements

- Ansible 2.9+

## Role Variables

| Variable   | Default | Comments (type)  |
| :---       | :---    | :---             |
| `openio_netdata_namespace` | `"{{ namespace \| d('OPENIO') }}"` | OpenIO Namespace |
| `openio_netdata_maintenance_mode` | `"{{ openio_maintenance_mode \| d(false) }}"` | Maintenance mode |
| `openio_netdata_bind_address` | `{{ openio_mgmt_bind_address \| d(ansible_default_ipv4.address) }}` |  Binding IP address. |
| `openio_netdata_bind_port` | `6921` |  Listening port. |
| `openio_netdata_global_update_every` | `10` |  The frequency for data collection (in seconds). |

## Dependencies
- https://github.com/open-io/ansible-role-openio-service

## Example Playbook

```yaml
- hosts: all
  gather_facts: true
  become: true

  tasks:
    - include_role:
        name: netdata
```

## Contributing

Issues, feature requests, ideas are appreciated and can be posted in the Issues section.

Pull requests are also very welcome.
The best way to submit a PR is by first creating a fork of this Github project, then creating a topic branch for the suggested change and pushing that branch to your own fork.
Github can then easily create a PR based on that branch.

## License
Copyright (C) 2015-2020 OpenIO SAS
