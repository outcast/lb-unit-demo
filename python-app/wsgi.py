import os
import datetime
import sys
from pprint import pformat as pf

def application(environ, start_response):
    output = datetime.datetime.now().strftime("%Y-%m-%d %I:%M:%S %p")
    output += "\n\nPython: "
    output += sys.version
    output += "\n\nENV Variables:\n\n"
    for param in os.environ.keys():

         output += param
         output += "\t"
         output += os.environ[param]
         output += "\n"
    for param in environ.keys():
         output += param
         output += "\t"
         output += pf(environ[param])
         output += "\n"
    start_response('200 OK', [('Content-type', 'text/plain')])
    return [s.encode('utf8') for s in output]
