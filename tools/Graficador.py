import numpy as np 

import matplotlib.pyplot as plt
from math import pi
import io
import base64

class Graficador():
    def __init__(self, data):
        self.data = data
        self.bytes = io.BytesIO()

    def crear_grafica_lineal(self):
        plt.figure(figsize=(6.6,6.6))
        ax = plt.subplot()
        ax.set_title(self.data["title"])
        ax.set_xlabel(self.data["xlabel"])
        ax.set_ylabel(self.data["ylabel"])
        cont = 1
        for data_list in self.data["data"]:
            if(cont <= 2):
                marker = "D"
            else:
                marker = "^"
            ax.plot(data_list,marker=marker)
            cont = cont + 1
        plt.xticks(np.arange(len(self.data["data"][0])), self.data["xticks"])
        plt.yticks(np.arange(0,105,10))
        ax.set_yticklabels(['{:,.1f}'.format(x) + '%' for x in ax.get_yticks()])
        ax.set_ylim(0,100)
        plt.legend(self.data["labels"],labelspacing=0.1, fontsize='small')
        plt.savefig(self.bytes)
        self.bytes.seek(0)
        plt.close()
        return base64.b64encode(self.bytes.read()).decode('utf-8')
