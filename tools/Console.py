import argparse
from . import Server
class Console(object):
    def __init__(self):
        self.parser = argparse.ArgumentParser()
        self.parser.add_argument('--host','-H',nargs='?',type=str,default='0.0.0.0',help='recibe el host con el cual estara escuchando el servidor, 0.0.0.0 para todas las ip')
        self.parser.add_argument('--port','-P',nargs='?',type=int,default=8001,help='Recibe el puerto en el cual estara escuchado el servidor')
        self.parser.add_argument('--debug',default=True, action="store_true", help='modo debug')
        self.args = self.parser.parse_args()
    
    def iniciar_consola(self):
        server = Server("reportes")
        server.app.run(host=self.args.host,port=self.args.port,debug=self.args.debug)
