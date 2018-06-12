# Christopher Iliffe Sprague
# christopher.iliffe.sprague@gmail.com

import numpy as np, multiprocessing as mp
import imperium.segment as segment, pygmo as pg

class Trajectory(object):

    def __init__(self, dynamics):

        # segments
        self.dynamics = dynamics

    def set_state_bounds(self, state_bounds):

        # compute number of segments
        self.nseg = len(state_bounds) - 1

        # store bounds
        self.slb = np.array([s[0] for s in state_bounds], float)
        self.sub = np.array([s[1] for s in state_bounds], float)

    def set_duration_bounds(self, Tlb, Tub):
        self.Tlb, self.Tub = Tlb, Tub

class Indirect(Trajectory):

    def __init__(self, segments):

        # initialise base
        Trajectory.__init__(self, segments)

    def set_state_bounds(self, state_bounds):

        # set state bounds
        Trajectory.set_state_bounds(self, state_bounds)

        # instantiate segments
        self.segments = [segment.Indirect(self.dynamics) for i in range(self.nseg)]

    def set_duration_bounds(self, Tlb, Tub):
        Trajectory.set_duration_bounds(self, Tlb, Tub)
        if Tlb == Tub:
            self.freetime = False
        else:
            self.freetime = True

    def get_bounds(self):
        lb = np.hstack((
            np.full((self.nseg, 1), self.Tlb),
            self.slb[1:],
            np.full((self.nseg, self.dynamics.sdim), -100)
        )).flatten()
        lb = np.hstack((self.slb[0], lb))
        ub = np.hstack((
            np.full((self.nseg, 1), self.Tub),
            self.sub[1:],
            np.full((self.nseg, self.dynamics.sdim), 100)
        )).flatten()
        ub = np.hstack((self.sub[0], ub))
        return lb, ub

    def decode(self, z):

        # extract durations, states, and costates
        Tl, sl, ll = np.hsplit(z[self.dynamics.sdim:].reshape((self.nseg, 1 + self.dynamics.sdim*2)), [1, 1 + self.dynamics.sdim])

        # node times
        tl = np.hstack((0, Tl.flatten().cumsum()))

        # node states
        sl = np.vstack((z[:self.dynamics.sdim], sl))

        return tl, sl, ll

    def mismatch(self, i):
        return self.segments[i].mismatch()

    def fitness(self, z):

        # [s00, T0, sf0, l00, ..., Tf, sff, l0f]

        # extract node times, states, and costates
        tl, sl, ll = self.decode(z)

        # set segments
        for i in range(self.nseg):
            self.segments[i].set(tl[i], sl[i], tl[i+1], sl[i+1], ll[i])
            self.segments[i].freetime = False

        # if free time
        if self.freetime: self.segments[-1].freetime = True

        # compute mismatch
        ceq = np.hstack([self.segments[i].mismatch() for i in range(self.nseg)])
        #ceq = np.hstack(self.map(self.mismatch, range(self.nseg)))

        '''
        # enforce costate continuation
        for i in range(self.nseg - 1):

            # final costates
            lf = self.segments[i].states[-1, self.dynamics.sdim:]

            # mismatch
            ceq = np.hstack(([1], ceq, self.segments[i+1].l0 - lf))

        '''

        # enforce time order
        ciq = [tl[i] - tl[i+1] for i in range(self.nseg)]

        return np.hstack(([1], ceq, ciq))

    def get_nec(self):
        nec = self.dynamics.sdim*self.nseg + 1# + self.dynamics.sdim*(self.nseg - 1)
        return nec

    def get_nic(self):
        return self.nseg

    def get_nobj(self):
        return 1

    def gradient(self, z):
        return pg.estimate_gradient(self.fitness, z)

    def nondimensionalise(self):

        # nondimensionalise state bounds
        self.slb = np.apply_along_axis(self.dynamics.nondim_state, 1, self.slb)
        self.sub = np.apply_along_axis(self.dynamics.nondim_state, 1, self.sub)

        # nondimensionalise time bounds
        self.Tlb /= self.dynamics.T
        self.Tub /= self.dynamics.T

        # nondimensionalise dynamics
        self.dynamics.nondim_params()

    def dimensionalse(self):

        # redimensionalise state bounds
        self.slb = np.apply_along_axis(self.dynamics.dim_state, 1, self.slb)
        self.sub = np.apply_along_axis(self.dynamics.dim_state, 1, self.sub)

        # nondimensionalise time bounds
        self.Tlb *= self.dynamics.T
        self.Tub *= self.dynamics.T

        # dimensionalise dynamics
        self.dynamics.dim_params()

    def solve(self, otol=1e-5, atol=1e-10, rtol=1e-10):

        # nondimensionalise problem
        self.nondimensionalise()

        # instantiate optimisation problem
        prob = pg.problem(self)

        # instantiate algorithm
        algo = pg.ipopt()
        algo.set_numeric_option("tol", otol)
        algo = pg.algorithm(algo)
        algo.set_verbosity(1)

        # instantiate and evolve population
        pop = pg.population(prob, 1)
        pop = algo.evolve(pop)

        # extract soltution
        self.zopt = pop.champion_x
        self.fitness(self.zopt)

        # set states and times
        self.states = np.vstack(([self.segments[i].states for i in range(self.nseg)]))
        self.times = np.hstack((self.segments[i].times for i in range(self.nseg)))
        self.controls = np.apply_along_axis(self.dynamics.control, 1, self.states)

        # redimensionalise problem
        self.dimensionalse()

        # redimensionalise records
        self.times *= self.dynamics.T
        self.states[:, :self.dynamics.sdim] = np.apply_along_axis(self.dynamics.dim_state, 1, self.states[:, :self.dynamics.sdim])
