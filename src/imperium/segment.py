# Christopher Iliffe Sprague
# christopher.iliffe.sprague@gmail.com

from scipy.integrate import ode
import numpy as np

class Segment(object):

    def __init__(self, dynamics, alpha, bounds=None):

        # dynamical system
        self.dynamics = dynamics

        # system parameters
        self.alpha = alpha

        # control bounds
        self.bounds = bounds

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

    def propagate(self, u, atol=1e-8, rtol=1e-8):

        # numerical integrator
        integrator = ode(
            lambda t, s: self.dynamics.eom_state(
                *s, *u, *self.alpha
            ).flatten(),
            lambda t, s: self.dynamics.jacobian_eom_state(
                *s, *u, *self.alpha
            )
        )

        # reset trajectory records
        self.times = np.empty((1, 0))
        self.states = np.empty((0, len(self.s0)))

        # set integration method
        integrator.set_integrator('dop853', atol=atol, rtol=rtol, verbosity=1)

        # set recorder
        integrator.set_solout(self.recorder)

        # set departure configuration
        integrator.set_initial_value(self.s0, self.t0)

        # numerically integrate
        integrator.integrate(self.tf)


class Indirect(Segment):

    def __init__(self, dynamics, alpha, bounds=None):

        # initialise base class
        Segment.__init__(self, dynamics, alpha, bounds)

    def propagate(self, l0, beta, bounded=True, atol=1e-8, rtol=1e-8):

        # define controller
        if bounded:
            control = lambda fs, alpha, beta: np.array([min(max(u, lb), ub) for u, lb, ub in zip(self.dynamics.control(*fs, *self.alpha, *beta).flatten(), self.lb, self.ub)])


        control = lambda fs, alpha, beta: self.dynamics.control(*fs, *self.alpha, *beta).flatten()

        # bound control
        if bounded:
            control = lambda fs, alpha, beta: np.array([min(max(u, bound[0]), bound[1]) for u, bound in zip(self.dynamics.control(*fs, *self.alpha, *beta).flatten(), self.bounds)])

        # numerical integrator
        integrator = ode(
            lambda t, fs: self.dynamics.eom_fullstate(
                *fs, *control(fs, self.alpha, beta), *self.alpha, *beta
            ).flatten(),
            lambda t, fs: self.dynamics.jacobian_eom_fullstate(
                *fs, *control(fs, self.alpha, beta), *self.alpha, *beta
            )
        )

        # reset trajectory records
        self.times = np.empty((1, 0))
        self.states = np.empty((0, len(self.s0)*2))

        # set integration method
        integrator.set_integrator('dop853', atol=atol, rtol=rtol, verbosity=1)

        # set recorder
        integrator.set_solout(self.recorder)

        # set departure configuration
        integrator.set_initial_value(np.hstack((self.s0, l0)), self.t0)

        # numerically integrate
        integrator.integrate(self.tf)

if __name__ == "__main__":

    from dynamics import auv2d
    seg = Segment(auv2d, (10, 1.225, 1, 10, 0.8))
    seg.set(0, np.array([0, 0, 0, 0]), 100, np.array([10, 10, 0, 0]))
    seg.propagate(np.array([1, 1, 1]))
