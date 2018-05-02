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
        # lagrangian cost functional
        self.L  = lagrangian

        # system parameters
        self.alpha = Matrix([
            var for var in dynamics.free_symbols if all([
                var not in vec for vec in [self.s, self.u]
            ])
        ])
        # homotopy parameters
        self.beta = Matrix([
            var for var in lagrangian.free_symbols if all([
                var not in vec for vec in [self.s, self.u, self.ds]
            ])
        ])

        # costate
        self.l  = Matrix([symbols('lambda_' + str(var)) for var in self.s])
        # hamiltonian
        self.H  = self.l.dot(self.ds) + self.L
        # costate dynamics
        self.dl = -Matrix([self.H.diff(var) for var in self.s])

        # jacobians
        self.dds  = self.ds.jacobian(self.s)
        self.ddl  = self.dl.jacobian(self.s)
        self.fs   = Matrix([self.s, self.l])
        self.dfs  = Matrix([self.ds, self.dl])
        self.ddfs = self.dfs.jacobian(self.fs)

        # optimal controls
        self.us = list()

        for var in self.u:
            # maximimise hamiltonian
            sol = solve(self.H.diff(var), var)
            self.us.append(sol[0])


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

    System(s, u, ds, L)
