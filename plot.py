import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import io
from functions import *


def generate_svg_plot(dictionary, min, max, liste_cord, width):

    # img
    imgdata = io.BytesIO()

    # creation des listes des abscisses et ordonnees
    lx = []
    ly = []

    for coord in liste_cord:
        lx.append(coord[0])
        ly.append(coord[1])

    # creation des valeurs en abscisses et en ordonnee avec les listes lx et ly
    x1 = np.array(lx)
    y1 = np.array(ly)

    plt.figure(figsize=(width, width))
    plt.axis([min, max, 0., 1.])
    plt.plot(x1, y1, 'ko', label="Original Data")
    x = np.linspace(min, max, 100)
    for func in dictionary.keys():
        if func == 'exp':
            a = dictionary[func]['a']
            b = dictionary[func]['b']
            c = dictionary[func]['c']
            plt.plot(x, funcexp(x, a, b, c), '#401539',
                     label="Exp Fitted Curve")

        elif func == 'quad':
            a = dictionary[func]['a']
            b = dictionary[func]['b']
            c = dictionary[func]['c']
            plt.plot(x, funcquad(x, a, b, c), '#458C8C',
                     label="Quad Fitted Curve")

        elif func == 'pow':
            a = dictionary[func]['a']
            b = dictionary[func]['b']
            c = dictionary[func]['c']
            plt.plot(x, funcpuis(x, a, b, c), '#6DA63C',
                     label="Pow Fitted Curve")

        elif func == 'log':
            a = dictionary[func]['a']
            b = dictionary[func]['b']
            c = dictionary[func]['c']
            d = dictionary[func]['d']
            plt.plot(x, funclog(x, a, b, c, d),
                     '#D9585A', label="Log Fitted Curve")

        elif func == 'lin':
            a = dictionary[func]['a']
            b = dictionary[func]['b']
            plt.plot(x, funclin(x, a, b), '#D9B504', label="Lin Fitted Curve")

    plt.savefig(imgdata, format='svg')
    plt.close()

    return imgdata.getvalue()

def pie_chart(name1, name2, proba1, proba2):

    imgdata = io.BytesIO()

    labels = name1,name2
    sizes = [proba1, proba2]
    plt.pie(sizes, labels=labels)

    plt.savefig(imgdata, format='svg')
    plt.close()

    return imgdata.getvalue()
