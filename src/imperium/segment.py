# Christopher Iliffe Sprague
# christopher.iliffe.sprague@gmail.com

from scipy.integrate import ode
import numpy as np, pygmo as pg

class Segment(object):

    # Trajectory formed between two boundary conditions.
    # Can be optimised soley or implemented in imperium.trajectory.

    def __init__(self, dynamics):
        # dynamical system and its state bounds
        self.dynamics = dynamics
        # numerical integerator
        self.integrator = ode(self.eom, self.eom_jac)

    def set_state_bounds(self, slb, sub):
        self.slb, self.sub = self.slb, self.sub

    def set_times(self, t0, tf):
        self.t0 = float(t0)
        self.tf = float(tf)

    def set_states(self, s0, sf):
        self.s0 = np.array(s0)
        self.sf = np.array(sf)

    def set(self, t0, s0, tf, sf):
        self.set_times(t0, tf)
        self.set_states(s0, sf)

    def record(self, t, s):
        # times and states
        self.times = np.append(self.times, t)
        self.states = np.vstack((self.states, s))

    def nondimensionalise(self):
        self.t0 /= self.dynamics.T
        self.tf /= self.dynamics.T
        self.s0 = self.dynamics.nondim_state(self.s0)
        self.sf = self.dynamics.nondim_state(self.sf)
        self.dynamics.nondim_params()
        return self.t0, self.s0, self.tf, self.sf

    def dimensionalise(self):
        # redimensionalise
        self.t0 *= self.dynamics.T
        self.tf *= self.dynamics.T
        self.s0 = self.dynamics.dim_state(self.s0)
        self.sf = self.dynamics.dim_state(self.sf)
        self.dynamics.dim_params()
        return self.t0, self.s0, self.tf, self.sf


class Indirect(Segment):

    # Pontryagin's maximum principle.
    # Must solve for segment duration and initial costates.
    # z = [T, l0]

    def __init__(self, dynamics, freetime):

        # initialise base
        Segment.__init__(self, dynamics)

        # free time transversality condition
        self.freetime = bool(freetime)

    def eom(self, t, fs):
        u = self.dynamics.control(fs)
        return self.dynamics.eom_fullstate(fs, u)

    def eom_jac(t, fs):
        u = self.dynamics.control(fs)
        return self.dynamics.jacobian_eom_fullstate(fs, u)

    def set_costates(self, l):
        self.l0 = np.array(l)

    def set(self, t0, s0, tf, sf, l0):

        # set states and times
        Segment.set(self, t0, s0, tf, sf)

        # set costates
        self.set_costates(l0)

    def reset_records(self):
        self.times = np.empty((1, 0))
        self.states = np.empty((0, len(self.s0)*2))

    def dimensionalise_record(self):
        # dimensionalse times and states
        self.times *= self.dynamics.T
        self.states[:, :4] = np.apply_along_axis(self.dynamics.dim_state, 1, self.states[:, :4])

    def propagate(self, intmeth='dop853', atol=1e-8, rtol=1e-8):

        # reset trajectory records
        self.reset_records()

        # set integration method
        self.integrator.set_integrator(intmeth, atol=atol, rtol=rtol, verbosity=1)

        # set recorder
        self.integrator.set_solout(self.record)

        # set initial state
        self.integrator.set_initial_value(np.hstack((self.s0, self.l0)), self.t0)

        # integrate
        self.integrator.integrate(self.tf)

        return self.times, self.states

    def mismatch(self, intmeth='dop853', atol=1e-14, rtol=1e-14):

        # propagate the trajectory
        self.propagate(intmeth=intmeth, atol=atol, rtol=rtol)

        # extract final states, costates, and controls
        fsf = self.states[-1]
        sf = fsf[:len(self.s0)]
        lf = fsf[len(self.s0):]
        uf = self.dynamics.control(fsf)

        # compute mismatch
        ceq = sf - self.sf

        # if free time problem
        if self.freetime:

            # compute final hamiltonian
            H = self.dynamics.hamiltonian(fsf, uf)

            # add to equality constraint
            ceq = np.hstack((ceq, [H]))

        return ceq

    def get_nobj(self):
        return 1

    def get_nec(self):
        neq = len(self.s0)
        if self.freetime:
            neq += 1
        return neq

    def get_bounds(self):
        lb = [self.dynamics.T/100] + [-10]*len(self.s0)
        ub = [self.dynamics.T] + [10]*len(self.s0)
        return (lb, ub)

    def fitness(self, z):

        # duration
        self.set_times(0, z[0])

        # initial costates
        self.set_costates(z[1:])

        # compute mismatch
        ceq = self.mismatch()

        return np.hstack(([1], ceq))

    def gradient(self, z):
        return pg.estimate_gradient(self.fitness, z)

    def solve(self, tol=1e-5):

        # nondimensionalise problem
        self.nondimensionalise()

        # instantiate optimisation problem
        prob = pg.problem(self)

        # instantiate algorithm
        algo = pg.ipopt()
        algo.set_numeric_option("tol", tol)
        algo = pg.algorithm(algo)
        algo.set_verbosity(1)

        # instantiate and evolve population
        pop = pg.population(prob, 1)
        pop = algo.evolve(pop)

        # extract solution
        zopt = pop.champion_x
        self.fitness(zopt)

        # redimensionalise problem
        self.dimensionalise()

        # redimensionalise records
        self.dimensionalise_record()
