import numpy as np
from imperium import dynamics

def test1():

    print("Running test 1.")

    # define arbitrary system
    sys = dynamics.base(5, 5)

    # arbitrary vector
    a = np.array([1, 2, 3, 4, 5])

    # comute eom_state
    b = sys.eom_state(a)

    print(b)


if __name__ == "__main__":

    test1()
