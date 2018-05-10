# Christopher Iliffe Sprague
# christopher.iliffe.sprague@gmail.com

from sympy import *
from sympy.utilities.codegen import *
from sympy.parsing.sympy_parser import parse_expr

class system(object):

    def __init__(self, state, control, dynamics, lagrangian, equality=None, inequality=None):

        # state variables
        self.s  = state
        # control variables
        self.u  = control
        # state dynamics
        self.ds = dynamics
        # lagrangian cost functional
        self.L  = lagrangian
        # equality constraints
        self.eq = equality
        # inequality constraints
        self.iq = inequality

        # system parameters - constant
        self.alpha = Matrix([
            var for var in dynamics.free_symbols if all([
                var not in self.s.free_symbols | self.u.free_symbols
            ])
        ])

        # homotopy parameters - psuedoconstant
        self.beta = Matrix([
            var for var in lagrangian.free_symbols if all([
                var not in self.s.free_symbols | self.u.free_symbols | self.ds.free_symbols
            ])
        ])

        # costate
        self.l  = Matrix([symbols('lambda_' + str(var)) for var in self.s])
        # dynamic variables
        self.gamma = Matrix([var for var in self.s.free_symbols | self.l.free_symbols | self.u.free_symbols])
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

        # hamiltonian gradient and Hessian wrt controls
        self.grad = Matrix([self.H.diff(var) for var in self.u])
        self.hess = Matrix([[self.H.diff(x).diff(y) for x in self.u] for y in self.u])

        # KKT equations and variables to solve
        self.opteqs, self.optvars = list(), list()

        # stationarity equation
        self.stationarity = self.grad

        # equality constraint constants
        if self.eq is not None:
            self.eqcoef = Matrix([symbols('zeta' + str(i), positive=True, real=True) for i in range(len(self.eq))])
            self.stationarity -= sum([coef*Matrix([con.diff(var) for var in self.u]) for coef, con in zip(self.eqcoef, self.eq)], zeros(len(self.u), 1))
            [self.optvars.append(var) for var in self.eqcoef]

        # inequality constraints
        if self.iq is not None:
            self.iqcoef = Matrix([symbols('eta' + str(i), real=True) for i in range(len(self.iq))])
            self.stationarity -= sum([coef*Matrix([con.diff(var) for var in self.u]) for coef, con in zip(self.iqcoef, self.iq)], zeros(len(self.u), 1))
            self.compslack = Matrix([coef*con for coef, con in zip(self.iqcoef, self.iq)])
            [self.opteqs.append(eq) for eq in self.compslack]
            [self.optvars.append(var) for var in self.iqcoef]

        [self.opteqs.append(eq) for eq in self.stationarity]
        [self.optvars.append(var) for var in self.u]

    def solve(self):

        # generic solutions
        sols = solve(self.opteqs, self.optvars, dict=True, simplify=True)

        # remove dynamic coefficients
        self.sol = list()
        for sol in sols:
            good = True

            if self.eq is not None:
                for coef in self.eqcoef:
                    if any([var in sol[coef].free_symbols for var in self.gamma]):
                        good = False
                        break

            if self.iq is not None:
                for coef in self.iqcoef:
                    if any([var in sol[coef].free_symbols for var in self.gamma]):
                        good = False
                        break

            if good: self.sol.append(sol)

        return self.sol






    def codegen(self, path, lang='C'):

        # ordered result variable names
        fresvars = ['ds', 'dds', 'dl', 'ddl', 'dfs', 'ddfs', 'L', 'H', 'uo']

        # ordered result variable values
        fresvals = [self.__dict__[var] for var in fresvars]

        # function expressions
        fexps = list()
        for resvar, resval in zip(fresvars, fresvals):
            try: fexps.append(Eq(MatrixSymbol(resvar, *resval.shape), resval))
            except: fexps.append(Eq(symbols(resvar), resval))

        # ordered function arguments
        fargs = [
            [self.s,  self.u, self.alpha],
            [self.s,  self.u, self.alpha],
            [self.fs, self.u, self.alpha, self.beta],
            [self.fs, self.u, self.alpha, self.beta],
            [self.fs, self.u, self.alpha, self.beta],
            [self.fs, self.u, self.alpha, self.beta],
            [self.s,  self.u, self.alpha, self.beta],
            [self.fs, self.u, self.alpha, self.beta],
            [self.fs, self.alpha, self.beta]
        ]

        fargs = [[var for vec in args for var in vec] for args in fargs]
        [args.append(fexp.lhs) for args, fexp in zip(fargs, fexps)]

        # code generator
        if lang == 'C':
            gen = CCodeGen()
        elif lang == 'F':
            gen = FCodeGen()

        # create routines
        routines = [
            gen.routine(name, func, sym, None)
            for name, func, sym in zip(fresvars, fexps, fargs)
        ]

        # write routines to file
        gen.write(routines, path, to_files=True, header=False, empty=True)

class system_parse(system):

    def __init__(self, jsconf):

        s  = Matrix([parse_expr(var) for var in jsconf['state']])
        u  = Matrix([parse_expr(var) for var in jsconf['control']])
        ds = Matrix([parse_expr(var) for var in jsconf['dynamics']])
        L  = parse_expr(jsconf['lagrangian'])

        if 'equality' in jsconf.keys():
            eq = Matrix([parse_expr(var) for var in jsconf['equality']])
        else:
            eq = None

        if 'inequality' in jsconf.keys():
            iq = Matrix([parse_expr(var) for var in jsconf['inequality']])
        else:
            eq = None

        system.__init__(self, s, u, ds, L, eq, iq)





if __name__ == "__main__":

    import os
    fp = os.path.realpath(__file__)
    fp = os.path.split(fp)[0] + "/car"

    sys = {
        'state': ['x', 'y', 'theta'],
        'control': ['u'],
        'dynamics': ['V*cos(theta)', 'V*sin(theta)', 'u*omega'],
        'lagrangian': 'u**2',
        'inequality': ['u - 1', '-u - 1'],
        'equality': ['0']
    }

    # instantiate system
    sys = system_parse(sys)

    # generate C code
    sys.solve()
