import os
import re


class FilterModule(object):
    def filters(self):
        return {
            'services_by_path': self.services_by_path,
            'beanstalks_by_status2': self.beanstalks_by_status2,
            'ip_port': self.ip_port,
        }

    def services_by_path(self, paths):
        services = list()

        for path in paths:
            path_splitted = path.split(os.sep)
            ns = path_splitted[4]
            service_type, id = path_splitted[5].split('-')
            services.append({'ns': ns, 'service_type': service_type, 'id': id})
        return services

    def beanstalks_by_status2(self, command_lines):
        services = list()

        for line in command_lines:
            line_splitted = re.split(" +", line)
            ns, service_type, id = line_splitted[0].split('-')
            ip = line_splitted[10]
            port = line_splitted[12]
            services.append({'ns': ns, 'service_type': service_type, 'id': id,
              'ip': ip, 'port': port})
        return services

    def ip_port(self, ip_port):
        services = list()

        for pair in ip_port:
            ip, port = pair.split(':')
            services.append({'ip': ip, 'port': port})
        return services
