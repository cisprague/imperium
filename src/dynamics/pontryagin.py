# Christopher Iliffe Sprague
# christopher.iliffe.sprague@gmail.com

from sympy import *
from sympy.utilities.codegen import *
from sympy.parsing.sympy_parser import parse_expr

class system(object):

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
        self.uo = Matrix([solve(self.H.diff(var), var)[0] for var in self.u])

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
        system.__init__(self, s, u, ds, L)







if __name__ == "__main__":

    # state
    sys = {
        'state': ['x', 'y', 'theta'],
        'control': ['omega'],
        'dynamics': ['V*cos(theta)', 'V*sin(theta)', 'omega'],
        'lagrangian': 'omega**2'
    }
