import sys
sys.path.append("/home/cisprague/Dev/imperium/src")
from imperium.dynamics import auv2d
from imperium.segment import Indirect
from imperium.environments.algae import Algae_Farm
import matplotlib.pyplot as plt
import numpy as np, pygmo as pg, pygmo_plugins_nonfree as pg7

def main():

    # create an algae farm
    farm = Algae_Farm(5, 5, 2, 6, 10, 40, 40)
    pts = farm.simple_coverage()

    # create first segment
    seg = Indirect("auv2d", [10, 10], [100, 10, 100], [0, -1, -1], [1, 1, 1], True)

    # departure state
    t0 = 0
    s0 = np.array([farm.dsx, farm.dsy, 0, 0])
    tf = 100
    sf = np.hstack((pts[-1], [0, 0]))
    seg.set(0, np.array([farm.dsx, farm.dsy, 0, 0]), 10, sf, np.random.randn(4), [0], True)

    # optimisation problem
    prob = pg.problem(seg)

    # instantiate SNOPT algorithm
    algo = pg7.snopt7(True, "/usr/lib/libsnopt7_c.so")
    algo.set_integer_option("Major iterations limit", 4000)
    algo.set_integer_option("Iterations limit", 40000)
    algo.set_numeric_option("Major optimality tolerance", 1e-2)
    algo.set_numeric_option("Major feasibility tolerance", 1e-8)
    algo = pg.algorithm(algo)

    # instantiate population
    pop = pg.population(prob, 1)
    pop = algo.evolve(pop)
    print(pop.champion_x)

if __name__ == "__main__":
    main()
