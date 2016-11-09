# libraries import
#from pylab import *
import numpy as np
from scipy.optimize import curve_fit
import traceback
from functions import *
from functools import partial
#from scipy import numpy
#import matplotlib.pyplot as plt
#import sys


def regressions(liste_cord, liste=False, dictionnaire={}):

    # creation des fonctions utilisees pour les differentes
    # creation d'un dictionnaire pour stocker les donnees essentielles
    myList = []
    # creation des listes des abscisses et ordonnees
    lx = []
    ly = []

    for coord in liste_cord:
        lx.append(coord[0])
        ly.append(coord[1])

    # creation des valeurs en abscisses et en ordonnee avec les listes lx et ly
    x = np.array(lx)
    y = np.array(ly)

    if y[-1] == 1:
        min = x[-2]
        max = x[-1]
    else:
        min = x[-1]
        max = x[-2]

    # creation of the fitted curves

    try:
        # exponential function
        funcexpParam = lambda x, b: funcexp2(x, b, min, max)
        # fonction regression utilisant la funcexp du fichier functions.py avec CI
        # nulles
        popt1, pcov1 = curve_fit(funcexpParam, x, y, [0.1])
        # popt1 = matrice ligne contenant les coefficients de la regression exponentielle optimisee apres calcul / popcov1 = matrice de covariances pour cette regression exp
        # ajout des coeeficients a, b et c dans le dictionnaire pour la regression
        # exponentielle
        b1 = popt1[0]
        a1 = (1. / (np.exp(-b1 * max) - np.exp(-b1 * min)))
        c1 = (1. / (1 - np.exp(b1 * (min - max))))
        dictionnaire['exp'] = {}
        dictionnaire['exp']['a'] = a1
        dictionnaire['exp']['b'] = b1
        dictionnaire['exp']['c'] = c1
        # calcul et affichage du mean squared error et du r2
        # print "Mean Squared Error exp : ", np.mean((y-funcexp(x, *popt1))**2)
        ss_res = np.dot((y - funcexp(x, a1, b1, c1)), (y - funcexp(x, a1, b1, c1)))
        ymean = np.mean(y)
        ss_tot = np.dot((y - ymean), (y - ymean))
        # ajout du r2 dans le dictionnaire pour la regression exponentielle
        dictionnaire['exp']['r2'] = 1 - ss_res / ss_tot
        myList.append(dictionnaire)
    except:
        pass


    try:
        # Meme principe pour la quadratic function
        funcquadParam = lambda x, b: funcquad2(x, b, min, max)
        popt2, pcov2 = curve_fit(funcquadParam, x, y, [0.1])
        b2 = popt2[0]
        a2 = b2 * min**2 - min*((1 + b2 * (max**2 - min**2)) / (max - min))
        c2 = (1 + b2 * (max**2 - min**2)) / (max - min)
        dictionnaire['quad'] = {}
        dictionnaire['quad']['a'] = a2
        dictionnaire['quad']['b'] = b2
        dictionnaire['quad']['c'] = c2
        # print "Mean Squared Error quad : ", np.mean((y-funcquad(x,
        # *popt2))**2)
        ss_res = np.dot((y - funcquad(x, a2, b2, c2)), (y - funcquad(x, a2, b2, c2)))
        ymean = np.mean(y)
        ss_tot = np.dot((y - ymean), (y - ymean))
        dictionnaire['quad']['r2'] = 1 - ss_res / ss_tot
        myList.append(dictionnaire)
    except Exception,e: print str(e)

    try:
        # Meme principe pour la puissance function
        funcpuisParam = lambda x, b: funcpuis2(x, b, min, max)
        popt3, pcov3 = curve_fit(funcpuisParam, x, y, [0.1])
        b3=popt3[0]
        a3 = (1 - b3) / (max**(1 - b3) - min**(1 - b3))
        c3 = -(min**(1 - b3) - 1) / (max**(1 - b3) - min**(1 - b3))
        dictionnaire['pow'] = {}
        dictionnaire['pow']['a'] = a3
        dictionnaire['pow']['b'] = b3
        dictionnaire['pow']['c'] = c3
        # print "Mean Squared Error puis : ", np.mean((y-funcpuis(x,
        # *popt3))**2)
        ss_res = np.dot((y - funcpuis(x, a3, b3, c3)), (y - funcpuis(x, a3, b3, c3)))
        ymean = np.mean(y)
        ss_tot = np.dot((y - ymean), (y - ymean))
        dictionnaire['pow']['r2'] = 1 - ss_res / ss_tot
        myList.append(dictionnaire)
    except:
        pass

    try:
        # Meme principe pour la logarithmic function
        funclogParam = lambda x, b, c: funclog2(x, b, c, min, max)
        popt4, pcov4 = curve_fit(funclogParam, x, y, [0.1,0.1])
        b4=popt4[0]
        c4=popt4[1]
        a4 = 1. / (np.log(b4 * max + c4) - np.log(b4 * min + c4))
        d4 = 1. / (1 - np.log(b4 * max + c4) / np.log(b4 * min + c4))
        dictionnaire['log'] = {}
        dictionnaire['log']['a'] = a4
        dictionnaire['log']['b'] = b4
        dictionnaire['log']['c'] = c4
        dictionnaire['log']['d'] = d4
        # print "Mean Squared Error log : ", np.mean((y-funclog(x, *popt4))**2)
        ss_res = np.dot((y - funclog(x, a4, b4, c4, d4)), (y - funclog(x, a4, b4, c4, d4)))
        ymean = np.mean(y)
        ss_tot = np.dot((y - ymean), (y - ymean))
        dictionnaire['log']['r2'] = 1 - ss_res / ss_tot
        myList.append(dictionnaire)
    except:
        pass

    try:
		# Meme principe pour la linear function
		a5 = 1. / (max - min)
		b5 = -min / (max - min)
		dictionnaire['lin'] = {}
		dictionnaire['lin']['a'] = a5
		dictionnaire['lin']['b'] = b5
		# print "Mean Squared Error lin: ", np.mean((y-funclin(x, *popt5))**2)
		ss_res = np.dot((y - funclin(x, a5, b5)), (y - funclin(x, a5, b5)))
		ymean = np.mean(y)
		ss_tot = np.dot((y - ymean), (y - ymean))
		dictionnaire['lin']['r2'] = 1 - ss_res / ss_tot
		myList.append(dictionnaire)
    except:
        pass

    if liste:
        return (myList)
    else:
        return(dictionnaire)


def multipoints(liste_cord):
    liste_dictionnaires=[]
    dictionnaire = {}
    if len(liste_cord) == 3:
        dictionnaire['points'] = [1]
        liste_dictionnaires.append(regressions(liste_cord,dictionnaire=dictionnaire))
    elif len(liste_cord) == 4:
        dictionnaire['points'] = [1,2]
        liste_dictionnaires.append(regressions(liste_cord,dictionnaire=dictionnaire))
        dictionnaire['points'] = [1]
        liste=[liste_cord[0]]+liste_cord[2:]
        liste_dictionnaires.append(regressions(liste,dictionnaire=dictionnaire))
        dictionnaire['points'] = [2]
        liste=liste_cord[1:]
        liste_dictionnaires.append(regressions(liste,dictionnaire=dictionnaire))
    elif len(liste_cord) == 5:
        dictionnaire['points'] = [1,2,3]
        liste_dictionnaires.append(regressions(liste_cord,dictionnaire=dictionnaire))
        dictionnaire['points'] = [1,2]
        liste=liste_cord[:1]+liste_cord[3:]
        liste_dictionnaires.append(regressions(liste,dictionnaire=dictionnaire))
        dictionnaire['points'] = [1,3]
        liste=[liste_cord[0]]+liste_cord[2:]
        liste_dictionnaires.append(regressions(liste,dictionnaire=dictionnaire))
        dictionnaire['points'] = [2,3]
        liste=liste_cord[1:]
        liste_dictionnaires.append(regressions(liste,dictionnaire=dictionnaire))
        dictionnaire['points'] = [1]
        liste=[liste_cord[0]]+liste_cord[3:]
        liste_dictionnaires.append(regressions(liste,dictionnaire=dictionnaire))
        dictionnaire['points'] = [2]
        liste=[liste_cord[1]]+liste_cord[3:]
        liste_dictionnaires.append(regressions(liste,dictionnaire=dictionnaire))
        dictionnaire['points'] = [3]
        liste=liste_cord[2:]
        liste_dictionnaires.append(regressions(liste,dictionnaire=dictionnaire))
    return liste_dictionnaires







# La partie ci-dessous permet d'afficher sur python les points ainsi que
# les differentes regressions directement sur python avec leur legende
# respective


# #creation of the points and abscisse
# plt.plot(x, y, 'ko', label="Original Data")
# x=linspace(min(l1),max(l1),100)

# #creation of the exponential fitted curve
# plot(x,funcexp(x,*popt1), 'r-', label="Exp Fitted Curve")
# #creation of the quadratic fitted curve
# plot(x, funcquad(x,*popt2), 'b-', label="Quad Fitted Curve")
# #creation of the puissance fitted curve
# plot(x, funcpuis(x,*popt3), 'k-', label="Puis Fitted Curve")
# # #creation of the logarithmic fitted curve
# plot(x, funclog(x,*popt4), 'y-', label="Log Fitted Curve")
# #creation of the linear fitted curve
# plot(x, funclin(x,*popt5), 'm-', label="Lin Fitted Curve")

# display legend
# plt.legend()
# show on python
# show()
