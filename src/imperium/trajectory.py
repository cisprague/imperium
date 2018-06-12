# Christopher Iliffe Sprague
# christopher.iliffe.sprague@gmail.com

import numpy as np
import imperium.segment as segment

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
            self.freetime = True
        else:
            self.freetime = False

    def get_bounds(self):
        lb = np.hstack((
            np.full((self.nseg, 1), self.Tlb),
            self.slb[1:],
            np.full((self.nseg, self.dynamics.sdim), -10)
        )).flatten()
        lb = np.hstack((self.slb[0], lb))
        ub = np.hstack((
            np.full((self.nseg, 1), self.Tub),
            self.sub[1:],
            np.full((self.nseg, self.dynamics.sdim), 10)
        )).flatten()
        ub = np.hstack((self.sub[0], ub))
        return lb, ub

    def fitness(self, z):

        # [s00, T0, sf0, l00, ..., Tf, sff, l0f]

        # extract durations, states, and costates
        Tl, sl, ll = np.hsplit(z[self.dynamics.sdim:].reshape((self.nseg, 1 + self.dynamics.sdim*2)), [1, 1 + self.dynamics.sdim])
        Tl = Tl.flatten()

        # set initial state of first segment
        self.segments[0].set_state
