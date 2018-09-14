[![Build Status](https://travis-ci.org/open-io/ansible-role-openio-netdata.svg?branch=master)](https://travis-ci.org/open-io/ansible-role-openio-netdata)
# Ansible role `netdata`

An Ansible role for install netdata. Specifically, the responsibilities of this role are to:

- install netdata packages
- Install openio plugin

## Requirements

- Ansible 2.4+

## Role Variables

| Variable                                   | Description                                                       | Type    |
| ------------------------------------------ | ----------------------------------------------------------------- | ------- |
| openio_netdata_namespace                   | Namespace to monitor                                              | string  |
| openio_netdata_confdir                     | Path to netdata configuration directory                           | string  |
| openio_netdata_inventory_oio_group         | Group name of all the nodes running OpenIO                        | string  |
| openio_netdata_inventory_groupname         | Group name of targets where to install netdata                    | string  |
| openio_netdata_oio_container_plugin_target | Hostname of the node where the container plugin will be installed | string  |
| openio_netdata_bind_interface              | Network interface on which netdata listens                        | string  |
| openio_netdata_bind_address                | IP Address on which netdata listens                               | string  |
| openio_netdata_bind_port                   | Port on which netdata listens                                     | string  |
| openio_netdata_backend_hostname            | Hostname to report in netdata metrics                             | string  |
| openio_netdata_backend_update_every        | Interval on which to update collected metrics                     | integer |
| openio_netdata_backend_timeout_ms          | Metric collection timeout                                         | integer |
| openio_netdata_oio_plugins                 | OpenIO plugins configuration                                      | list    |
| openio_netdata_python_d_retry              | PythonD plugin autodiscovery retry timer                          | integer |



## Dependencies

Repositories need to be configured using:
- https://github.com/open-io/ansible-role-openio-repository

## Example Playbook

```yaml
- hosts: all
  gather_facts: true
  become: true
  roles:
    - role: openio-repository
    - role: netdata
```

## Example inventory:
```ini
[all]
192.168.1.2
192.168.1.3
192.168.1.4
```

## Contributing

Issues, feature requests, ideas are appreciated and can be posted in the Issues section.

Pull requests are also very welcome.
The best way to submit a PR is by first creating a fork of this Github project, then creating a topic branch for the suggested change and pushing that branch to your own fork.
Github can then easily create a PR based on that branch.

## License

Apache License, Version 2.0

## Contributors
- [Vladimir DOMBROVSKI](https://github.com/vdombrovski) (maintainer)
- [Cedric DELGEHIER](https://github.com/cdelgehier)
