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

    def set_state_bounds(self, s0lb, s0ub, sflb, sfub):
        self.s0lb, self.s0ub = np.array(s0lb, float), np.array(s0ub, float)
        self.sflb, self.sfub = np.array(sflb, float), np.array(sfub, float)

    def set_duration_bound(self, Tlb, Tub):
        self.Tlb = float(Tlb)
        self.Tub = float(Tub)

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
        self.Tlb /= self.dynamics.T
        self.Tub /= self.dynamics.T
        self.s0 = self.dynamics.nondim_state(self.s0)
        self.sf = self.dynamics.nondim_state(self.sf)
        self.s0lb = self.dynamics.nondim_state(self.s0lb)
        self.s0ub = self.dynamics.nondim_state(self.s0ub)
        self.sflb = self.dynamics.nondim_state(self.sflb)
        self.sfub = self.dynamics.nondim_state(self.sfub)
        self.dynamics.nondim_params()
        return self.t0, self.s0, self.tf, self.sf

    def dimensionalise(self):
        # redimensionalise
        self.t0 *= self.dynamics.T
        self.tf *= self.dynamics.T
        self.Tlb *= self.dynamics.T
        self.Tub *= self.dynamics.T
        self.s0 = self.dynamics.dim_state(self.s0)
        self.sf = self.dynamics.dim_state(self.sf)
        self.s0lb = self.dynamics.nondim_state(self.s0lb)
        self.s0ub = self.dynamics.nondim_state(self.s0ub)
        self.sflb = self.dynamics.nondim_state(self.sflb)
        self.sfub = self.dynamics.nondim_state(self.sfub)
        self.dynamics.dim_params()
        return self.t0, self.s0, self.tf, self.sf


class Indirect(Segment):

    # Pontryagin's maximum principle.
    # Must solve for segment duration and initial costates.
    # z = [s0, sf, l0, T]

    def __init__(self, dynamics):

        # initialise base
        Segment.__init__(self, dynamics)

    def eom(self, t, fs):
        u = self.dynamics.control(fs)
        return self.dynamics.eom_fullstate(fs, u)

    def eom_jac(t, fs):
        u = self.dynamics.control(fs)
        return self.dynamics.jacobian_eom_fullstate(fs, u)

    def set_costates(self, l):
        self.l0 = np.array(l)

    def set_state_bounds(self, s0lb, s0ub, sflb, sfub):

        # transversalities
        self.tv0, self.tvf = list(), list()

        # set bounds
        Segment.set_state_bounds(self, s0lb, s0ub, sflb, sfub)

        # extract transversality conditions
        for var0l, var0u, varfl, varfu in zip(s0lb, s0ub, sflb, sfub):

            if var0l == var0u:
                self.tv0.append(False)
            else:
                self.tv0.append(True)

            if varfl == varfu:
                self.tvf.append(False)
            else:
                self.tvf.append(True)

    def set_duration_bound(self, Tlb, Tub):

        # set bound
        Segment.set_duration_bound(self, Tlb, Tub)

        # transversality
        if Tlb == Tub:
            self.freetime = False
        else:
            self.freetime = True

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
        self.states[:, :self.dynamics.sdim] = np.apply_along_axis(self.dynamics.dim_state, 1, self.states[:, :self.dynamics.sdim])

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

        # fullstate
        fsf = self.states[-1]
        # final state
        sf = fsf[:self.dynamics.sdim]
        # intial and final costates
        l0 = self.states[0, self.dynamics.sdim:]
        lf = fsf[self.dynamics.sdim:]
        # final control
        uf = self.dynamics.control(fsf)

        # compute mismatch
        ceq = sf - self.sf

        # initial and final costates subject to transversality
        #ceq = np.hstack((ceq, l0[self.tv0]))
        #ceq = np.hstack((ceq, lf[self.tvf]))

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
        nec = self.dynamics.sdim
        #neq += sum(self.tv0)
        #nec += sum(self.tvf)
        if self.freetime:
            nec += 1
        return nec

    def get_bounds(self):
        lb = [self.Tlb, *self.s0lb, *self.sflb, *[-100]*self.dynamics.sdim]
        ub = [self.Tub, *self.s0ub, *self.sfub, *[100]*self.dynamics.sdim]
        return (lb, ub)

    def fitness(self, z, atol=1e-10, rtol=1e-10):

        # integration params
        self.atol = atol
        self.rtol = rtol

        # duration
        self.set_times(0, z[0])

        # extract states and costates
        s0, sf, l0 = z[1:].reshape((3, self.dynamics.sdim))

        # set states
        self.set_states(s0, sf)

        # initial costates
        self.set_costates(l0)

        # compute mismatch
        ceq = self.mismatch(atol=self.atol, rtol=self.rtol)

        return np.hstack(([1], ceq))

    def gradient(self, z):
        return pg.estimate_gradient(self.fitness, z)

    def solve(self, otol=1e-5, atol=1e-10, rtol=1e-10):

        # integration params
        self.otol = otol

        # random initialisation
        self.fitness(pg.random_decision_vector(*self.get_bounds()), rtol=rtol, atol=atol)

        # nondimensionalise problem
        self.nondimensionalise()

        # instantiate optimisation problem
        prob = pg.problem(self)

        # instantiate algorithm
        algo = pg.ipopt()
        algo.set_numeric_option("tol", self.otol)
        algo = pg.algorithm(algo)
        algo.set_verbosity(1)

        # instantiate and evolve population
        pop = pg.population(prob, 1)
        pop = algo.evolve(pop)

        # extract solution
        self.zopt = pop.champion_x
        self.fitness(self.zopt)

        # compute controls
        self.controls = np.apply_along_axis(self.dynamics.control, 1, self.states)

        # redimensionalise problem
        self.dimensionalise()

        # redimensionalise records
        self.dimensionalise_record()
