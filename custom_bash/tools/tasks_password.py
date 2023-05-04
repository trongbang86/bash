from auth_provider import *
import sys


class PasswordRetriever(object):
    def __init__(self):
        self.ap = AuthProvider()

    def main(self):
        args = sys.argv
        print(self.ap.load('ssh', args[1]))


if __name__ == '__main__':
    e = PasswordRetriever()
    e.main()
