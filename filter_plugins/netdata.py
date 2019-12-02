from base64 import b64decode
try:
    # Python 3
    import configparser
except ImportError:
    # Python 2
    import ConfigParser as configparser
    import io


class FilterModule(object):
    def filters(self):
        return {
            'aws_creds': self.aws_creds,
            'redis_roles': self.redis_roles
        }

    def aws_creds(self, data, type_='access'):
        """ Retrieves AWS creds from b64 encoded data received by slurp """
        config = configparser.ConfigParser()
        config.optionxform = str
        try:
            config.read_string(b64decode(data).decode('utf-8'))
        except AttributeError:
            config.readfp(io.BytesIO(b64decode(data)))
        if type_ == 'secret':
            return config.get('default', 'aws_secret_access_key')
        return config.get('default', 'aws_access_key_id')

    def redis_roles(self, services):
        """
        Organise redis services into clusters for the redis collector
        ---
        Example:
        services = [
            {"ip": "10.10.10.11", "port": 6011, "role": "account"},
            {"ip": "10.10.10.11", "port": 6411, "role": "ch"},
            {"ip": "10.10.10.11", "port": 6511, "role": "bdb"}
        ]
        self.redis_roles(services)
        > "10.10.10.11:6011:account,10.10.10.11:6411:ch,10.10.10.11:6511:bdb"
        """
        tmp = dict()
        res = []
        for service in services:
            tmp.setdefault(service['role'], [])
            tmp[service['role']].append(service)
        for idx, cluster in enumerate(tmp.values()):
            for service in cluster:
                res.append("%s:%d:%s" %
                           (service['ip'], service['port'], service['role']))
        return ",".join(res)
