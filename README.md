[![Build Status](https://travis-ci.org/open-io/ansible-role-openio-netdata.svg?branch=master)](https://travis-ci.org/open-io/ansible-role-openio-netdata)
# Ansible role `netdata`

An Ansible role for install netdata. Specifically, the responsibilities of this role are to:

- install netdata packages
- Install openio plugin

## Requirements

- Ansible 2.4+

## Role Variables


| Variable   | Default | Comments (type)  |
| :---       | :---    | :---             |
| `openio_netdata_active_plugins` | `` | ... |
| `openio_netdata_backend_charts` | `` | ... |
| `openio_netdata_backend_hostname` | `"{{ ansible_hostname }}"` | ... |
| `openio_netdata_backend_oio_charts` | ` "{{ openio_netdata_backend_standard_charts + openio_netdata_backend_oio_charts if openio_netdata_openio_host \` | ... |
| `openio_netdata_backend_standard_charts` | ` "{{ openio_netdata_backend_standard_charts + openio_netdata_backend_oio_charts if openio_netdata_openio_host \ else openio_netdata_backend_standard_charts }}"` | ... |
| `openio_netdata_backend_timeout_ms` | `20000` | ... |
| `openio_netdata_backend_update_every` | `10` | ... |
| `openio_netdata_bind_address` | `` | ... |
| `openio_netdata_bind_interface` | `"{{ ansible_default_ipv4.alias }}" "{{ hostvars[inventory_hostname]['ansible_' + openio_netdata_bind_interface]['ipv4']['address'] }}"` | ... |
| `openio_netdata_bind_port` | `19999` | ... |
| `openio_netdata_inventory_groupname` | `all "{{ hostvars[ groups[openio_netdata_inventory_groupname][0] ]['ansible_hostname' ] }}"` | ... |
| `openio_netdata_namespace` | `"OPENIO"` | ... |
| `openio_netdata_oio_container_hostname` | `` | ... |
| `openio_netdata_oio_host` | `false` | ... |
| `openio_netdata_oio_plugins` | `` | ... |
| `openio_netdata_plugin_container_host` | `""` | ... |
| `openio_netdata_python_d_plugin_enabled` | `true` | ... |
## Dependencies

No dependencies.

## Example Playbook

```yaml
- hosts: all
  gather_facts: true
  become: true
  roles:
    - role: netdata
```


```ini
[all]
node1 ansible_host=192.168.1.173
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
