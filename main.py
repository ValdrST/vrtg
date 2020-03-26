import json
from tools import Console
from tools import Server
application = Server("aw-reportes").app
def main():
    console = Console()
    console.iniciar_consola()

if __name__ == "__main__":
    main()
