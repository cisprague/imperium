# Christopher Iliffe Sprague
# christopher.iliffe.sprague@gmail.com

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
