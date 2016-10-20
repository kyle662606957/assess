# libraries import
#from pylab import *
import numpy as np
from scipy.optimize import curve_fit
import traceback
from functions import *
#from scipy import numpy
#import matplotlib.pyplot as plt
import sys

def regressions(liste_cord):

	# creation des fonctions utilisees pour les differentes
	# creation d'un dictionnaire pour stocker les donnees essentielles
	dictionnaire = {}

	# creation des listes des abscisses et ordonnees
	lx = []
	ly = []

	for coord in liste_cord:
		lx.append(coord[0])
		ly.append(coord[1])

	# creation des valeurs en abscisses et en ordonnee avec les listes lx et ly
	x = np.array(lx)
	y = np.array(ly)


	# creation of the fitted curves

	try:
		# exponential function
		popt1, pcov1 = curve_fit(funcexp, x, y,[0,0,0]) # fonction regression utilisant la funcexp cree en l14 avec CI nulles
		#popt1 = matrice ligne contenant les coefficients de la regression exponentielle optimisee apres calcul / popcov1 = matrice de covariances pour cette regression exp
		# ajout des coeeficients a, b et c dans le dictionnaire pour la regression exponentielle
		dictionnaire['exp'] = {}
		dictionnaire['exp']['a']=popt1[0]
		dictionnaire['exp']['b']=popt1[1]
		dictionnaire['exp']['c']=popt1[2]

		# calcul et affichage du mean squared error et du r2
		#print "Mean Squared Error exp : ", np.mean((y-funcexp(x, *popt1))**2)
		ss_res = np.dot((y - funcexp(x, *popt1)),(y - funcexp(x, *popt1)))
		ymean = np.mean(y)
		ss_tot = np.dot((y-ymean),(y-ymean))

		# ajout du r2 dans le dictionnaire pour la regression exponentielle
		dictionnaire['exp']['r2']= 1-ss_res/ss_tot
	except:
		pass


	try:
		# Meme principe pour la quadratic function
		popt2, pcov2 = curve_fit(funcquad,x,y)
		dictionnaire['quad'] = {}
		dictionnaire['quad']['a']=popt2[0]
		dictionnaire['quad']['b']=popt2[1]
		dictionnaire['quad']['c']=popt2[2]
		#print "Mean Squared Error quad : ", np.mean((y-funcquad(x, *popt2))**2)
		ss_res = np.dot((y - funcquad(x, *popt2)),(y - funcquad(x, *popt2)))
		ymean = np.mean(y)
		ss_tot = np.dot((y-ymean),(y-ymean))
		dictionnaire['quad']['r2']= 1-ss_res/ss_tot
	except:
		pass

	try:
		# Meme principe pour la puissance function
		popt3, pcov3 = curve_fit(funcpuis, x,y)
		dictionnaire['pow'] = {}
		dictionnaire['pow']['a']=popt3[0]
		dictionnaire['pow']['b']=popt3[1]
		dictionnaire['pow']['c']=popt3[2]
		#print "Mean Squared Error puis : ", np.mean((y-funcpuis(x, *popt3))**2)
		ss_res = np.dot((y - funcpuis(x, *popt3)),(y - funcpuis(x, *popt3)))
		ymean = np.mean(y)
		ss_tot = np.dot((y-ymean),(y-ymean))
		dictionnaire['pow']['r2']= 1-ss_res/ss_tot
	except:
		pass

	try:
		# Meme principe pour la logarithmic function
		popt4, pcov4 = curve_fit(funclog, x,y)
		dictionnaire['log'] = {}
		dictionnaire['log']['a']=popt4[0]
		dictionnaire['log']['b']=popt4[1]
		dictionnaire['log']['c']=popt4[2]
		dictionnaire['log']['d']=popt4[3]
		#print "Mean Squared Error log : ", np.mean((y-funclog(x, *popt4))**2)
		ss_res = np.dot((y - funclog(x, *popt4)),(y - funclog(x, *popt4)))
		ymean = np.mean(y)
		ss_tot = np.dot((y-ymean),(y-ymean))
		dictionnaire['log']['r2']= 1-ss_res/ss_tot
	except:
		pass

	try:
		# Meme principe pour la linear function
		popt5, pcov5 = curve_fit(funclin, x,y)
		dictionnaire['lin'] = {}
		dictionnaire['lin']['a']=popt5[0]
		dictionnaire['lin']['b']=popt5[1]
		#print "Mean Squared Error lin: ", np.mean((y-funclin(x, *popt5))**2)
		ss_res = np.dot((y - funclin(x, *popt5)),(y - funclin(x, *popt5)))
		ymean = np.mean(y)
		ss_tot = np.dot((y-ymean),(y-ymean))
		dictionnaire['lin']['r2']= 1-ss_res/ss_tot
	except:
		pass

	return(dictionnaire)



def regressions_under_list_form(liste_cord):

    # creation des fonctions utilisees pour les differentes
    # creation d'un dictionnaire pour stocker les donnees essentielles
    dictionnaire = {}
    myList=[]

    # creation des listes des abscisses et ordonnees
    lx = []
    ly = []

    for coord in liste_cord:
        lx.append(coord[0])
        ly.append(coord[1])

    # creation des valeurs en abscisses et en ordonnee avec les listes lx et ly
    x = np.array(lx)
    y = np.array(ly)


    # creation of the fitted curves


    try:
        # exponential function
        popt1, pcov1 = curve_fit(funcexp, x, y, [0,0,0]) # fonction regression utilisant la funcexp cree en l14 avec CI nulles
        #popt1 = matrice ligne contenant les coefficients de la regression exponentielle optimisee apres calcul / popcov1 = matrice de covariances pour cette regression exp
        # ajout des coeeficients a, b et c dans le dictionnaire pour la regression exponentielle
        dictionnaire={};
        dictionnaire['type']='exp'
        dictionnaire['a']=popt1[0]
        dictionnaire['b']=popt1[1]
        dictionnaire['c']=popt1[2]

        # calcul et affichage du mean squared error et du r2
        #print "Mean Squared Error exp : ", np.mean((y-funcexp(x, *popt1))**2)
        ss_res = np.dot((y - funcexp(x, *popt1)),(y - funcexp(x, *popt1)))
        ymean = np.mean(y)
        ss_tot = np.dot((y-ymean),(y-ymean))

        # ajout du r2 dans le dictionnaire pour la regression exponentielle
        dictionnaire['r2']= 1-ss_res/ss_tot
        myList.append(dictionnaire)

    except:
        pass


    try:
        # Meme principe pour la quadratic function
        popt2, pcov2 = curve_fit(funcquad,x,y, [0,0,0])
        dictionnaire = {}
        dictionnaire['type']='quad'
        dictionnaire['a']=popt2[0]
        dictionnaire['b']=popt2[1]
        dictionnaire['c']=popt2[2]
        #print "Mean Squared Error quad : ", np.mean((y-funcquad(x, *popt2))**2)
        ss_res = np.dot((y - funcquad(x, *popt2)),(y - funcquad(x, *popt2)))
        ymean = np.mean(y)
        ss_tot = np.dot((y-ymean),(y-ymean))
        dictionnaire['r2']= 1-ss_res/ss_tot
        myList.append(dictionnaire)
    except:
        pass

    try:
        # Meme principe pour la puissance function
        popt3, pcov3 = curve_fit(funcpuis, x,y, [0,0,0])
        dictionnaire = {}
        dictionnaire['type']='pow'
        dictionnaire['a']=popt3[0]
        dictionnaire['b']=popt3[1]
        dictionnaire['c']=popt3[2]
        #print "Mean Squared Error puis : ", np.mean((y-funcpuis(x, *popt3))**2)
        ss_res = np.dot((y - funcpuis(x, *popt3)),(y - funcpuis(x, *popt3)))
        ymean = np.mean(y)
        ss_tot = np.dot((y-ymean),(y-ymean))
        dictionnaire['r2']= 1-ss_res/ss_tot
        myList.append(dictionnaire)
    except:
        pass

    try:
        # Meme principe pour la logarithmic function
        popt4, pcov4 = curve_fit(funclog, x,y , [0,0,1,0])
        dictionnaire = {}
        dictionnaire['type']='log'
        dictionnaire['a']=popt4[0]
        dictionnaire['b']=popt4[1]
        dictionnaire['c']=popt4[2]
        dictionnaire['d']=popt4[3]
        #print "Mean Squared Error log : ", np.mean((y-funclog(x, *popt4))**2)
        ss_res = np.dot((y - funclog(x, *popt4)),(y - funclog(x, *popt4)))
        ymean = np.mean(y)
        ss_tot = np.dot((y-ymean),(y-ymean))
        dictionnaire['r2']= 1-ss_res/ss_tot
        myList.append(dictionnaire)
    except:
        pass

    try:
        # Meme principe pour la linear function
        popt5, pcov5 = curve_fit(funclin, x,y, [0,0])
        dictionnaire = {}
        dictionnaire['type']='lin'
        dictionnaire['a']=popt5[0]
        dictionnaire['b']=popt5[1]
        #print "Mean Squared Error lin: ", np.mean((y-funclin(x, *popt5))**2)
        ss_res = np.dot((y - funclin(x, *popt5)),(y - funclin(x, *popt5)))
        ymean = np.mean(y)
        ss_tot = np.dot((y-ymean),(y-ymean))
        dictionnaire['r2']= 1-ss_res/ss_tot
        myList.append(dictionnaire)
    except:
        pass

    return(myList)




# La partie ci-dessous permet d'afficher sur python les points ainsi que les differentes regressions directement sur python avec leur legende respective



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
