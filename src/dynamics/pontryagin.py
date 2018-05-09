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

        # hamiltonian gradient wrt controls
        self.grad = Matrix([self.H.diff(var) for var in self.u])
        # hamiltonian hessian wrt controls
        self.hess = Matrix([[self.H.diff(x).diff(y) for x in self.u] for y in self.u])



        #self.uo = Matrix([solve(self.H.diff(var), var)[0] for var in self.u])

    def solve(self):

        # equality constraint constants - positive for dual feasibility
        if self.eq is not None:
            self.eqcoef = Matrix([symbols('zeta' + str(i), positive=True, real=True) for i in range(len(self.eq))])

        # equality constraint constants
        if self.iq is not None:
            self.iqcoef = Matrix([symbols('eta' + str(i), real=True) for i in range(len(self.iq))])

        # stationarity equation
        self.stationarity = self.grad
        if self.eq is not None:
            self.stationarity -= sum([coef*Matrix([con.diff(var) for var in self.u]) for coef, con in zip(self.iqcoef, self.iq)], zeros(len(self.u), 1))
        if self.iq is not None:
            self.stationarity -= sum([coef*Matrix([con.diff(var) for var in self.u]) for coef, con in zip(self.eqcoef, self.eq)], zeros(len(self.u), 1))

        # complementary slackness
        if self.iq is not None:
            self.compslack = Matrix([coef*con for coef, con in zip(self.iqcoef, self.iq)])

        # equations to solve
        self.opteqs = [eq for sl in
            [
                [eq for eq in self.stationarity],
                [eq for eq in self.compslack]
            ]
            for eq in sl]

        #print(self.compslack)

        # variables to solve for
        self.optvars = [var for sl in
                [
                    [var for var in self.u],
                    [var for var in self.eqcoef],
                    [var for var in self.iqcoef]
                ]
            for var in sl]

        self.sol = solve(self.opteqs, self.optvars)



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
        eq = Matrix([parse_expr(var) for var in jsconf['equality']])
        iq = Matrix([parse_expr(var) for var in jsconf['inequality']])
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
