# Christopher Iliffe Sprague
# christopher.iliffe.sprague@gmail.com

import numpy as np
from imperium.segment import Indirect

class Trajectory(object):

    def __init__(self, dynamics):

        # segments
        self.dynamics = dynamics


class Indirect(Trajectory):

    def __init__(self, segments):

        # initialise base
        Trajectory.__init__(self, segments)


    def fitness(self, z):

        # z = [s00, T0, l00, sf0, ..., TN, l0N, sfN]

        z = z.reshape((1 + self.segments[0].dynamics.sdim*2, self.nbc))
