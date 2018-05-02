# Christopher Iliffe Sprague
# christopher.iliffe.sprague@gmail.com

from sympy import *

class System(object):

    def __init__(self, state, control, dynamics, lagrangian):

        # state variables
        self.s  = state
        # control variables
        self.u  = control
        # state dynamics
        self.ds = dynamics
        # Lagrangian cost functional
        self.L  = lagrangian
        # a priori parameters
        self.alpha = Matrix([var for var in dynamics.free_symbols if all([var not in vec for vec in [state, control]])])
        # a posteriori parameters
        self.beta = Matrix([var for var in lagrangian.free_symbols if all([var not in vec for vec in [state, control, dynamics]])])

    def pontryagin(self):


        # costate
        l = Matrix([symbols('lambda_' + str(var)) for var in state])

        # hamiltonian
        H = l.dot(dynamics) + lagrangian

        # costate dynamics
        dl = -Matrix([])


if __name__ == "__main__":

    # state
    x, y, theta = symbols('x y theta', real=True)
    p = Matrix([x, y])
    s = Matrix([p, [theta]])

    # control
    omega = symbols('omega', real=True)
    u = Matrix([omega])

    # a priori parameters
    V = symbols('V', real=True, positive=True)

    # a posteriori parameters
    a = symbols('a', real=True, positive=True)

    # state dynamics
    dx = V*cos(theta)
    dy = V*sin(theta)
    dtheta = omega
    ds = Matrix([dx, dy, dtheta])

    # lagrangian
    L = a*omega**2
    L

    pontryagin(s, u, ds, L)
