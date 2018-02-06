import numpy as np


def funcexp(x, a, b, c):			# function for the exponential regression
    return a * np.exp(-b * x) + c


def funcquad(x, a, b, c):			# function for the quadratic regression
    return c * x - b * x**2 + a


def funcpuis(x, a, b, c):			# function for the puissance regression
    return a * ((x**(1 - b) - 1) / (1 - b)) + c


def funclog(x, a, b, c, d):			# function for the logarithmic regression
    return a * np.log(b * x + c) + d


def funclin(x, a, b):				# function for the linear regression
    return a * x + b


def funcexpopower(x, a, b, c):             # function for the expo-power regression
    return a + np.exp(-b * x**c)


# Fonctions parametrees pour avoir U(xmin_val)=0 et U(xmax_val)=1
def funcexp2(x, b, min_val, max_val):
    return (1. / (np.exp(-b * max_val) - np.exp(-b * min_val))) * np.exp(-b * x) + (1. / (1 - np.exp(b * (min_val - max_val))))


def funcquad2(x, b, min_val, max_val):
    return ((1 + b * (max_val**2 - min_val**2)) / (max_val - min_val)) * x - b * x**2 + b * min_val**2 - min_val * ((1 + b * (max_val**2 - min_val**2)) / (max_val - min_val))


def funcpuis2(x, b, min_val, max_val):
    return ((1 - b) / (max_val**(1 - b) - min_val**(1 - b))) * ((x**(1 - b) - 1) / (1 - b)) - (min_val**(1 - b) - 1) / (max_val**(1 - b) - min_val**(1 - b))


def funclog2(x, b, c, min_val, max_val):
    return (1. / (np.log(b * max_val + c) - np.log(b * min_val + c))) * np.log(b * x + c) + 1. / (1 - np.log(b * max_val + c) / np.log(b * min_val + c))


def funcexpopower2(x, a, min_val, max_val):
    return (a + np.exp(np.log(-a) * (x / min_val)**(np.log(np.log(1 - a) / np.log(-a)) / np.log(max_val / min_val))))


# Fonctions utilisees pour l'export Excel
def funcexp_excel(x, a, b, c):
    return "="+a+"*EXP(-"+b+"*"+x+")+"+c


def funcquad_excel(x, a, b, c):
    return "="+c+"*"+x+"-"+b+"*"+x+"^2+"+a


def funcpuis_excel(x, a, b, c):
    return "="+a+"*("+x+"^(1-"+b+")-1)/(1-"+b+")+"+c


def funclog_excel(x, a, b, c, d):
    return "="+a+"*LOG("+b+"*"+x+"+"+c+")+"+d


def funclin_excel(x, a, b):
    return "="+a+"*"+x+"+"+b


def funcexpopower_excel(x, a, b, c):
    return "="+a+"+EXP(-"+b+"*"+x+"^"+c+")"


a=2
b=2
c=2
d=2
min_val=100
max_val=200

x=np.arange(0, 10, .01)
x1=funcexp2(x, b, min_val, max_val)
x2=funcquad2(x, b, min_val, max_val)
x3=funcpuis2(x, b, min_val, max_val)
x4=funclog2(x, b, c, min_val, max_val)
x5=funcexpopower2(x, a, min_val, max_val)
