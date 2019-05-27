import os
import re

import io
from base64 import b64decode
try:
    import configparser
except ImportError:
    import ConfigParser as configparser


class FilterModule(object):
    def filters(self):
        return {
            'services_by_path': self.services_by_path,
            'beanstalks_by_status2': self.beanstalks_by_status2,
            'ip_port': self.ip_port,
            'aws_creds': self.aws_creds
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

    def aws_creds(self, data, type_='access'):
        """ Retrieves AWS creds from b64 encoded data received by slurp """
        data = b64decode(data)
        config = configparser.ConfigParser()
        config.optionxform = str
        config.readfp(io.BytesIO(data))
        if type_ == 'secret':
            return config.get('default', 'aws_secret_access_key')
        return config.get('default', 'aws_access_key_id')
