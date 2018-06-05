# Christopher Iliffe Sprague
# christopher.iliffe.sprague@gmail.com

from scipy.integrate import ode
import numpy as np, pygmo as pg
import imperium.dynamics as dynamics

class Segment(object):

    # NOTE: only dimensional parameters are state and system parameters

    def __init__(self, dn, alpha, ndunits, lbound=None, ubound=None):

        # dynamical system
        self.dn = dn

        # system parameters
        self.alpha = np.array(alpha, float)

        # nondimensionalisation units
        self.ndunits = np.array(ndunits, float)

        # control bounds
        self.ulb, self.uub = lbound, ubound

    def set_times(self, t0, tf):
        self.t0 = float(t0)
        self.tf = float(tf)

    def set_states(self, s0, sf):
        self.s0 = np.array(s0, float)
        self.sf = np.array(sf, float)

    def set(self, t0, s0, tf, sf):
        self.set_times(t0, tf)
        self.set_states(s0, sf)

    def record(self, t, s):

        # times
        self.times = np.append(self.times, t)

        # states
        self.states = np.vstack((self.states, s))

    def nondimensionalise(self, t0=None, tf=None, s0=None, sf=None, alpha=None):

        # nondimensionalise times
        if t0 is not None: t0 /= self.ndunits[0]
        if tf is not None: tf /= self.ndunits[0]

        # nondimensionalise states
        if s0 is not None: s0 = dynamics.__dict__[self.dn].nondimensionalise_state(*s0, *self.ndunits).flatten()
        if sf is not None: sf = dynamics.__dict__[self.dn].nondimensionalise_state(*sf, *self.ndunits).flatten()

        # nondimensionalise parameters
        if alpha is not None: alpha = dynamics.__dict__[self.dn].nondimensionalise_parameters(*alpha, *self.ndunits).flatten()

        return t0, tf, s0, sf, alpha

    def dimensionalise(self, t0=None, tf=None, s0=None, sf=None, alpha=None):

        # dimensionalise times
        if t0 is not None: t0 *= self.ndunits[0]
        if tf is not None: tf *= self.ndunits[0]

        # dimensionalise states
        if s0 is not None: s0 = dynamics.__dict__[self.dn].dimensionalise_state(*s0, *self.ndunits).flatten()
        if sf is not None: sf = dynamics.__dict__[self.dn].dimensionalise_state(*sf, *self.ndunits).flatten()

        # dimensionalise parameters
        if alpha is not None: alpha = dynamics.__dict__[self.dn].dimensionalise_parameters(*alpha, *self.ndunits).flatten()

        return t0, tf, s0, sf, alpha



class Indirect(Segment):

    def __init__(self, dynamics, alpha, ndunits, lbound, ubound, freetime):

        # initialise base
        Segment.__init__(self, dynamics, alpha, ndunits, lbound, ubound)

        # free time transversality condition
        self.freetime = freetime

        # numerical integerator
        self.integrator = ode(self.eom, self.eom_jac)

    def set_costates(self, l):
        self.l0 = np.array(l)

    def set(self, t0, s0, tf, sf, l0, beta, bound):

        # set states and times
        Segment.set(self, t0, s0, tf, sf)
        # set costates
        self.set_costates(l0)
        # set homotopy parameters
        self.beta = beta
        # set control bounds
        self.bound = bound

    def record(self, t, fs):

        # extract real state
        s = fs[:int(len(fs)/2)]
        # extract costate
        l = fs[int(len(fs)/2):]

        # redimensionalise time and state
        t, _, s, _, _ = self.dimensionalise(s0=s, t0=t)

        # record state and time
        Segment.record(self, t, np.hstack((s, l)))

        # record control
        self.controls = np.vstack((self.controls, self.control(fs)))

    def control(self, fs):

        # unbounded control
        u = dynamics.__dict__[self.dn].control(*fs, *self.alpha, *self.beta).flatten()
        # bounded control
        if self.bound:
            u = np.array([min(max(var, lb), ub) for var, lb, ub in zip(u, self.ulb, self.uub)])
        return u

    def eom(self, t, fs):

        # state transition
        return dynamics.__dict__[self.dn].eom_fullstate(*fs, *self.control(fs), *self.alpha, *self.beta).flatten()

    def eom_jac(t, fs):

        # state transition jacobian
        return dynamics.__dict__[self.dn].jacobian_eom_fullstate(*fs, *self.control(fs), *self.alpha, *self.beta)

    def propagate(self, intmeth='dop853', atol=1e-8, rtol=1e-8):

        # reset trajectory records
        self.times = np.empty((1, 0))
        self.states = np.empty((0, len(self.s0)*2))
        self.controls = np.empty((0, len(self.ulb)))

        # set integration method
        self.integrator.set_integrator(intmeth, atol=atol, rtol=rtol, verbosity=1)

        # set recorder
        self.integrator.set_solout(self.record)

        # nondimensionalise problem
        self.t0, self.tf, self.s0, self.sf, self.alpha = self.nondimensionalise(self.t0, self.tf, self.s0, self.sf, self.alpha)

        # set initial state
        self.integrator.set_initial_value(np.hstack((self.s0, self.l0)), self.t0)

        # integrate
        self.integrator.integrate(self.tf)

        # redimensionalise
        self.t0, self.tf, self.s0, self.sf, self.alpha = self.dimensionalise(self.t0, self.tf, self.s0, self.sf, self.alpha)

    def mismatch(self, intmeth='dop853', atol=1e-12, rtol=1e-12, norm=True):

        # propagate the trajectory
        self.propagate(intmeth=intmeth, atol=atol, rtol=rtol)

        # extract final states, costates, and controls
        sf = self.states[-1, :len(self.s0)]
        lf = self.states[-1, len(self.s0):]
        uf = self.controls[-1]

        # nondimensionalise states
        _, _, sf, _, _ = self.nondimensionalise(s0=sf)
        _, _, sft, _, _ = self.nondimensionalise(s0=self.sf)

        # compute mismatch
        ceq = sf - sft

        # if free time problem
        if self.freetime:

            # compute final hamiltonian
            H = dynamics.__dict__[self.dn].hamiltonian(*sf, *lf, *uf, *self.alpha, *self.beta)

            # add to equality constraint
            ceq = np.hstack((ceq, [H]))

        # normalise constraint vector
        if norm:
            ceq = ceq/np.linalg.norm(ceq)

        return ceq

    def get_nobj(self):
        return 1

    def get_nec(self):
        neq = len(self.s0)
        if self.freetime: neq += 1
        return neq

    def get_bounds(self):
        lb = [self.ndunits[0]/1000] + [-100]*len(self.s0)
        ub = [self.ndunits[0]] + [100]*len(self.s0)
        return (lb, ub)

    def fitness(self, z):

        # duration
        self.set_times(0, z[0])

        # initial costates
        self.set_costates(z[1:])

        # compute mismatch
        ceq = self.mismatch(norm=False)

        return np.hstack(([1], ceq))

    def gradient(self, z):
        return pg.estimate_gradient(self.fitness, z)
