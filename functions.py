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


# Fonctions parametrees pour avoir U(xmin)=0 et U(xmax)=1
def funcexp2(x, b, min, max):
    return (1. / (np.exp(-b * max) - np.exp(-b * min))) * np.exp(-b * x) + (1. / (1 - np.exp(b * (min - max))))


def funcquad2(x, b, min, max):
    return ((1 + b * (max**2 - min**2)) / (max - min)) * x - b * x**2 + b * min**2 - min * ((1 + b * (max**2 - min**2)) / (max - min))


def funcpuis2(x, b, min, max):
    return ((1 - b) / (max**(1 - b) - min**(1 - b))) * ((x**(1 - b) - 1) / (1 - b)) - (min**(1 - b) - 1) / (max**(1 - b) - min**(1 - b))


def funclog2(x, b, c, min, max):
    return (1. / (np.log(b * max + c) - np.log(b * min + c))) * np.log(b * x + c) + 1. / (1 - np.log(b * max + c) / np.log(b * min + c))
