# Christopher Iliffe Sprague
# christopher.iliffe.sprague@gmail.com

import imperium.dynamics.fortran.auv2d as mod, numpy as np

class AUV2D(object):

    def __init__(self, thrust, mass, T, L):

        # properties
        self.thrust = thrust
        self.mass = mass

        # dimensions
        self.sdim = 4
        self.udim = 3

        # nondimensionalisation parameters
        self.T = T
        self.L = L
        self.M = self.mass

        # control bounds
        self.ulb = [0, -1, -1]
        self.uub = [1, 1, 1]

        # dynamic parameters
        self.homotopy = 0
        self.bound = True

    def eom_state(self, state, control):
        return mod.eom_state(*state, *control, self.thrust, self.mass).flatten()

    def jacobian_eom_state(self, state, control):
        return mod.jacobian_eom_state(*state, *control, self.thrust, self.mass)

    def eom_costate(self, state, costate, control):
        return mod.eom_costate(*state, *costate, *control, self.thrust, self.mass, self.homotopy).flatten()

    def jacobian_eom_costate(self, state, costate, control):
        return mod.jacobian_eom_costate(*state, *costate, *control, self.thrust, self.mass, self.homotopy)

    def eom_fullstate(self, fullstate, control):
        return mod.eom_fullstate(*fullstate, *control, self.thrust, self.mass, self.homotopy).flatten()

    def jacobian_eom_fullstate(self, fullstate, control):
        return mod.jacobian_eom_fullstate(*fullstate, *control, self.thrust, self.mass, self.homotopy)

    def lagrangian(self, state, control):
        return mod.lagrangian(*state, *control, self.thrust, self.mass, self.homotopy)

    def hamiltonian(self, fullstate, control):
        return mod.hamiltonian(*fullstate, *control, self.thrust, self.mass, self.homotopy)

    def control(self, fullstate):
        u = mod.control(*fullstate, self.thrust, self.mass, self.homotopy).flatten()
        if self.bound:
            u = np.array([min(max(var, lb), ub) for var, lb, ub in zip(u, self.ulb, self.uub)])
        return u

    def nondim_state(self, state):
        return mod.nondimensionalise_state(*state, self.T, self.L, self.M).flatten()

    def dim_state(self, state):
        return mod.dimensionalise_state(*state, self.T, self.L, self.M).flatten()

    def nondim_params(self):
        self.thrust, self.mass = mod.nondimensionalise_parameters(self.thrust, self.mass, self.T, self.L, self.M).flatten()
        return self.thrust, self.mass

    def dim_params(self):
        self.thrust, self.mass = mod.dimensionalise_parameters(self.thrust, self.mass, self.T, self.L, self.M).flatten()
        return self.thrust, self.mass
