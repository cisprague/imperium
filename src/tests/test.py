# Christopher Iliffe Sprague
# christopher.iliffe.sprague@hgmail.com

def auv2d_tst():

    import numpy as np
    from imperium.dynamics.auv2d import AUV2D

    s = np.array([10, 10, 10, 10])
    u = np.array([1, 1, 1])
    l = np.random.randn(len(s))
    fs = np.hstack((s, l))
    thrust = 10
    mass = 10
    T = 1000
    L = 100
    alpha = [0.9]
    sys = AUV2D(thrust, mass, T, L)

    print(sys.eom_state(s, u))
    print(sys.jacobian_eom_state(s, u))
    print(sys.eom_costate(s, l, u))
    print(sys.jacobian_eom_costate(s, l, u))
    print(sys.eom_fullstate(fs, u))
    print(sys.jacobian_eom_fullstate(fs, u))
    print(sys.lagrangian(s, u))
    print(sys.hamiltonian(fs, u))
    print(sys.control(fs))
    print(sys.nondim_state(s))
    print(sys.dim_state(s))
    print(sys.nondim_params())
    print(sys.dim_params())

def segment_tst():

    import numpy as np

    # instantiate dynamics
    from imperium.dynamics.auv2d import AUV2D
    thrust = 10
    mass = 10
    T = 1000
    L = 100
    alpha = [0.11]
    sys = AUV2D(thrust, mass, T, L)

    # instantiate indirect freetime segment with dynamics
    from imperium.segment import Indirect
    seg = Indirect(sys, True)

    # set the segment
    t0 = 0
    s0 = np.array([0, 0, 0, 0])
    tf = 1000
    sf = np.array([30, 30, 0, 0])
    l0 = np.random.randn(len(s0))
    seg.set(t0, s0, tf, sf, l0)

    # nondimensionalise segment for better numerics
    seg.nondimensionalise()

    # compute mismatch
    print(seg.mismatch(norm=True))

    # plot the trajectory
    import matplotlib.pyplot as plt
    plt.figure()
    plt.plot(seg.states[:, 0], seg.states[:, 1], "k.-")
    plt.show()

def trajectory_tst():

    import numpy as np, sys

    # instantiate dynamics
    from imperium.dynamics.auv2d import AUV2D
    thrust = 10
    mass = 10
    T = 1000
    L = 100
    alpha = [0.11]
    sys = AUV2D(thrust, mass, T, L)

    # instantiate indirect segments with dynamics
    from imperium.segment import Indirect
    segs = [Indirect(sys), Indirect(sys)]

    # instantiate indirect trajectory
    from imperium.trajectory import Indirect
    traj = Indirect(segs)







if __name__ == "__main__":
    import os, sys; sys.path.append(os.path.dirname(__file__) + "/..")

    #auv2d_tst()
    #segment_tst()
    trajectory_tst()
