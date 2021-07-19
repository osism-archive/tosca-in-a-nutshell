#
# Ystia Forge
# Copyright (C) 2018 Bull S. A. S. - Bull, Rue Jean Jaures, B.P.68, 78340, Les Clayes-sous-Bois, France.
# Use of this source code is governed by Apache 2 LICENSE that can be found in the LICENSE file.
#

import argparse
import time
import BaseHTTPServer

class MyHandler(BaseHTTPServer.BaseHTTPRequestHandler):
    def do_HEAD(s):
        s.send_response(200)
        s.send_header("Content-type", "text/html")
        s.end_headers()

    def do_GET(s):
        """Respond to a GET request."""
        s.send_response(200)
        s.send_header("Content-type", "text/html")
        s.end_headers()
        s.wfile.write("<html><head><title>A Very Simple Web Server on Ystia</title></head>")
        s.wfile.write("<body>")
        s.wfile.write("")
        s.wfile.write("<hr size=\"6\" color=\"0066A1\">")
        s.wfile.write("<center><h1>Welcome to Ystia Framework !</h1><center>")
        s.wfile.write("<hr size=\"6\" color=\"0066A1\">")
        s.wfile.write("</body></html>")


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Sample HTTP Server')
    parser.add_argument('port', type=int, help='Listening port for HTTP Server')
    args = parser.parse_args()
    server_class = BaseHTTPServer.HTTPServer
    httpd = server_class(('', args.port), MyHandler)
    print time.asctime(), "Sample Server Starts (port=%s)" % (args.port)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()
    print time.asctime(), "Sample Server Stops (port=%s)" % (args.port)
