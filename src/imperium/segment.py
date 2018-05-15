# Christopher Iliffe Sprague
# christopher.iliffe.sprague@gmail.com

from scipy.integrate import ode
import numpy as np

class Segment(object):

    def __init__(self, dynamics, alpha, lbound=None, ubound=None):

        # dynamical system
        self.dynamics = dynamics

        # system parameters
        self.alpha = alpha

        # control bounds
        self.ulb, self.uub = lbound, ubound

    def set_times(self, t0, tf):
        self.t0 = float(t0)
        self.tf = float(tf)

    def set_states(self, s0, sf):
        self.s0 = np.array(s0, dtype=float)
        self.sf = np.array(sf, dtype=float)

    def set(self, t0, s0, tf, sf):
        self.set_times(t0, tf)
        self.set_states(s0, sf)

    def recorder(self, t, s):

        # times
        self.times = np.append(self.times, t)

        # states
        self.states = np.vstack((self.states, s))

class Indirect(Segment):

    def __init__(self, dynamics, alpha, lbound, ubound):

        # initialise base
        Segment.__init__(self, dynamics, alpha, lbound, ubound)

        # numerical integerator
        self.integrator = ode(self.eom, self.eom_jac)

    def control(self, fs, beta, bound):

        # unbounded control
        u = self.dynamics.control(*fs, *self.alpha, *beta).flatten()
        # bounded control
        if bound:
            u = np.array([min(max(var, lb), ub) for var, lb, ub in zip(u, self.ulb, self.uub)])
        return u

    def eom(self, t, fs, beta, bound):

        # state transition
        return self.dynamics.eom_fullstate(*fs, *self.control(fs, beta, bound), *self.alpha, *beta)

    def eom_jac(t, fs, beta, bound):

        # state transition jacobian
        return self.dynamics.jacobian_eom_fullstate(*fs, *self.control(fs, beta, bound), *self.alpha, *beta)

    def propagate(self, l0, beta, bound=True, intmeth='dop853', atol=1e-8, rtol=1e-8):

        # reset trajectory records
        self.times, self.states = np.empty((1, 0)), np.empty((0, len(self.s0)*2))

        # set integration method
        self.integrator.set_integrator(intmeth, atol=atol, rtol=rtol, verbosity=1)

        # set recorder
        self.integrator.set_solout(self.recorder)

        # set initial state
        self.integrator.set_initial_value(np.hstack((self.s0, l0)), self.t0)

        # set function params
        self.integrator.set_f_params(beta, bound).set_jac_params(beta, bound)

        # integrate
        self.integrator.integrate(self.tf)
