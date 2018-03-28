// Christopher Iliffe Sprague
// christopher.iliffe.sprague@gmail.com

#pragma once
#include "dynamics.hpp"
#include <pybind11/numpy.h>
namespace py = pybind11;

namespace dynamics {

  struct auv_cylinder_tv_2d : public base {

    // parameters
    const double g, T, m, L, alpha, rho, Cd, A;

    // constructor
    auv_cylinder_tv_2d (const unsigned short int & sdim_, const unsigned short int & adim_) : base(sdim, adim) {};

    // destructor
    ~auv_cylinder_tv_2d (void) {};

    // state equations of motion (SEOM)
    const py::array_t<double> eom_state (
      const py::array_t<double, py::array::forcecast> & state_,
      const py::array_t<double, py::array::forcecast> & control_
    ) const {

    };

  };

};
