import pathlib
from configparser import ConfigParser


class AuthProvider(object):
    def __init__(self, path: pathlib.PosixPath = None):
        if not path:
            path = '/Users/bang/.pass'
        self.path = path
        self.config = ConfigParser()
        self.config.read(self.path)

    def load(self, section:str = "default", key:str = ""):
        return self.config.get(section, key)
