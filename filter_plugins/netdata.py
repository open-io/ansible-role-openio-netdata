import io
from base64 import b64decode
try:
    import configparser
except ImportError:
    import ConfigParser as configparser


class FilterModule(object):
    def filters(self):
        return {
            'aws_creds': self.aws_creds
        }

    def aws_creds(self, data, type_='access'):
        """ Retrieves AWS creds from b64 encoded data received by slurp """
        data = b64decode(data)
        config = configparser.ConfigParser()
        config.optionxform = str
        config.readfp(io.BytesIO(data))
        if type_ == 'secret':
            return config.get('default', 'aws_secret_access_key')
        return config.get('default', 'aws_access_key_id')
