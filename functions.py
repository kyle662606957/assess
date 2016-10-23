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
