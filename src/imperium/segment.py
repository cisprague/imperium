# Christopher Iliffe Sprague
# christopher.iliffe.sprague@gmail.com

from scipy.integrate import ode
import numpy as np

class Segment(object):

    # NOTE: only dimensional parameters are state and system parameters

    def __init__(self, dynamics, alpha, ndunits, lbound=None, ubound=None):

        # dynamical system
        self.dynamics = dynamics

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

    def nondimensionalise(self, t0, tf, s0, sf, alpha):

        # nondimensionalise times
        t0 /= self.ndunits[0]
        tf /= self.ndunits[0]

        # nondimensionalise states
        s0 = self.dynamics.nondimensionalise_state(*s0, *self.ndunits).flatten()
        sf = self.dynamics.nondimensionalise_state(*sf, *self.ndunits).flatten()

        # nondimensionalise parameters
        alpha = self.dynamics.nondimensionalise_parameters(*alpha, *self.ndunits).flatten()

        return t0, tf, s0, sf, alpha

    def dimensionalise(self, t0, tf, s0, sf, alpha):

        # dimensionalise times
        t0 *= self.ndunits[0]
        tf *= self.ndunits[0]

        # dimensionalise states
        s0 = self.dynamics.dimensionalise_state(*s0, *self.ndunits).flatten()
        sf = self.dynamics.dimensionalise_state(*sf, *self.ndunits).flatten()

        # dimensionalise parameters
        alpha = self.dynamics.dimensionalise_parameters(*alpha, *self.ndunits).flatten()

        return t0, tf, s0, sf, alpha



class Indirect(Segment):

    def __init__(self, dynamics, alpha, ndunits, lbound, ubound):

        # initialise base
        Segment.__init__(self, dynamics, alpha, ndunits, lbound, ubound)

        # numerical integerator
        self.integrator = ode(self.eom, self.eom_jac)

    def set(self, t0, s0, tf, sf, l0, beta, bound):

        # set states and times
        Segment.set(self, t0, s0, tf, sf)
        # set costates
        self.l0 = l0
        # set homotopy parameters
        self.beta = beta
        # set control bounds
        self.bound = bound

    def record(self, t, fs):

        # record state and time
        Segment.record(self, t, fs)

        # record control
        self.controls = np.vstack((self.controls, self.control(fs)))

    def control(self, fs):

        # unbounded control
        u = self.dynamics.control(*fs, *self.alpha, *self.beta).flatten()
        # bounded control
        if self.bound:
            u = np.array([min(max(var, lb), ub) for var, lb, ub in zip(u, self.ulb, self.uub)])
        return u

    def eom(self, t, fs):

        # state transition
        return self.dynamics.eom_fullstate(*fs, *self.control(fs), *self.alpha, *self.beta).flatten()

    def eom_jac(t, fs):

        # state transition jacobian
        return self.dynamics.jacobian_eom_fullstate(*fs, *self.control(fs), *self.alpha, *self.beta)

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
        t0, tf, s0, sf, alpha = self.nondimensionalise(self.t0, self.tf, self.s0, self.sf, self.alpha)

        # set initial state
        self.integrator.set_initial_value(np.hstack((s0, self.l0)), t0)

        # integrate
        self.integrator.integrate(tf)
