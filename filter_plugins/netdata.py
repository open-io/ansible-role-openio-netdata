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
            'aws_creds': self.aws_creds
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
