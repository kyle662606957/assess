import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import io

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
	y1= np.array(ly)

	# Fucntions
	def funcexp(x, a, b, c):			# fonction for the exponential regression
		return a * np.exp(-b * x) + c

	def funcquad(x, a, b, c):			# fonction for the quadratic regression
		return c*x-b*x**2+a

	def funcpuis(x, a, b, c):			# fonction for the puissance regression
		return a*(x**(1-b)-1)/(1-b) + c

	def funclog(x, a, b, c, d):			# fonction for the logarithmic regression
		return a*np.log(b*x+c)+d

	def funclin(x, a, b):				# fonction for the logarithmic regression
		return a*x+b
	plt.figure(figsize=(width, width))
	plt.plot(x1, y1, 'ko', label="Original Data")
	x = np.linspace(min,max,100)
	for func in dictionary.keys():
		if func == 'exp':
			a = dictionary[func]['a']
			b = dictionary[func]['b']
			c = dictionary[func]['c']
			if funcexp(99.*max/100,a,b,c)<1 and funcexp(101.*min/100,a,b,c)>0:
				plt.plot(x, funcexp(x,a,b,c), '#401539', label="Exp Fitted Curve")

		elif func == 'quad':
			a = dictionary[func]['a']
			b = dictionary[func]['b']
			c = dictionary[func]['c']
			if funcquad(99.*max/100,a,b,c)<1 and funcquad(101.*min/100,a,b,c)>0:
				plt.plot(x, funcquad(x,a,b,c), '#458C8C', label="Quad Fitted Curve") 

		elif func == 'pow':
			a = dictionary[func]['a']
			b = dictionary[func]['b']
			c = dictionary[func]['c']
			if funcpuis(99.*max/100,a,b,c)<1 and funcpuis(101.*min/100,a,b,c)>0:
				plt.plot(x, funcpuis(x,a,b,c), '#6DA63C', label="Pow Fitted Curve") 

		elif func == 'log':
			a = dictionary[func]['a']
			b = dictionary[func]['b']
			c = dictionary[func]['c']
			d= dictionary[func]['d']
			if funclog(99.*max/100,a,b,c,d)<1 and funclog(101.*min/100,a,b,c,d)>0:
				plt.plot(x, funclog(x,a,b,c, d), '#D9585A', label="Log Fitted Curve") 
		
		elif func == 'lin':
			a = 1./max 
			b = 0
			plt.plot(x, funclin(x,a,b), '#D9B504', label="Lin Fitted Curve") 
			
		 


	plt.savefig(imgdata, format='svg')
	plt.close()	

	return imgdata.getvalue()
