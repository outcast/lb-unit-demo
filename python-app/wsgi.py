import os
import datetime
import sys
import uuid
from pprint import pformat as pf

def getCookies(environ):
     cookies = {}
     if 'HTTP_COOKIE' in environ:
          for cookie in environ['HTTP_COOKIE'].split(';'):
               c = cookie.split('=')
               cookies[c[0].replace(" ", "")]=c[1].replace(" ", "")
     return cookies

def application(environ, start_response):
     output = datetime.datetime.now().strftime("%Y-%m-%d %I:%M:%S %p")
     output += "\n\nPython: "
     output += sys.version
     output += "\n\nENV Variables:\n\n"
     cookies = getCookies(environ)
     session_id = str(uuid.uuid1())
     if 'JSESSIONID' in cookies.keys():
          output += "\nCOOKIE FOUND\n\n----\n"
          session_id = cookies['JSESSIONID']

     for param in cookies.keys():
          output += "cookie_{}".format(param)
          output += "\t"
          output += cookies[param]
          output += "\n"

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

     start_response('200 OK', [('Content-type', 'text/plain'),('Set-Cookie','JSESSIONID='+str(session_id)),('Set-Cookie','foo=bar')])
     return [s.encode('utf8') for s in output]
