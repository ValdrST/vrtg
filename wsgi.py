#!/bin/python3

from main import application
from waitress import serve
serve(application, unix_socket='/run/waitress/vrtg.sock',unix_socket_perms='666',ident="vrtg",threads=20)
