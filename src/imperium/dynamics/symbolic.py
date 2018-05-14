# Christopher Iliffe Sprague
# christopher.iliffe.sprague@gmail.com

from sympy import *
from sympy.utilities.codegen import *
from sympy.parsing.sympy_parser import parse_expr
import os, sys

class System(object):

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
        self.l  = Matrix([symbols('lambda_' + str(var), real=True) for var in self.s])
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

    def KKT(self, subst=None):

        # define KKT Lagrangian
        self.KKTL = self.H

        # define KKT constant coefficients and add to KKT Lagrangian
        if self.eq is not None:
            self.eqcoef = Matrix([symbols('eta_' + str(i), real=True) for i in range(len(self.eq))])
            self.KKTL += self.eqcoef.dot(self.eq)
        if self.iq is not None:
            # 2) iqcoef >= 0
            self.iqcoef = Matrix([symbols('zeta_' + str(j), real=True, nonnegative=True) for j in range(len(self.iq))])
            self.KKTL += self.iqcoef.dot(self.iq)

        # 1) gradient of KKT Lagrangian wrt controls = 0
        self.KKTeqs = [self.KKTL.diff(var) for var in self.u]

        # 3)
        if self.iq is not None:
            [self.KKTeqs.append(coef * cons) for coef, cons in zip(self.iqcoef, self.iq)]

        # 5)
        if self.eq is not None:
            [self.KKTeqs.append(eq) for eq in self.eq]

        # optimisation variables
        self.KKTvars = [var for var in self.u]
        if self.eq is not None:
            [self.KKTvars.append(var) for var in self.eqcoef]
        if self.iq is not None:
            [self.KKTvars.append(var) for var in self.iqcoef]

        # add substitutions
        if subst is not None:
            self.KKTeqs = [eq.subs(subst) for eq in self.KKTeqs]


    def codegen(self, path, lang='F', compile=True):

        # ordered result variable names
        fresnames = ['eom_state', 'jacobian_eom_state', 'eom_costate', 'jacobian_eom_costate', 'eom_fullstate', 'jacobian_eom_fullstate', 'lagrangian', 'hamiltonian', 'control']
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
            for name, func, sym in zip(fresnames, fexps, fargs)
        ]

        # write routines to file
        gen.write(routines, path, to_files=True, header=False, empty=True)

        # compile
        if compile:
            # extension name
            ename = os.path.basename(path)
            # directory
            edir = os.path.dirname(os.path.abspath(path))
            # compile source and create python extension
            os.system("cd " + edir + " && f2py -c -m " + ename + " " + ename + ".f90 " + ename + ".h")

class system_parse(System):

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
            iq = None

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
