# Christopher Iliffe Sprague
# christopher.iliffe.sprague@gmail.com

import numpy as np

class Trajectory(object):

    def __init__(self, segments):

        # segments
        self.segments = segments

class Indirect(Trajectory):

    def __init__(self, segments):

        # initialise base
        Trajectory.__init__(self, segments)

    def fitness(self, z):

        # z = [T0, l00, sf0, ..., TN, l0N, sfN]
        z = z.reshape((1 + self.segments[0].dynamics.sdim*2, self.nbc))


if __name__ == "__main__":

    pass
