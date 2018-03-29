// Christopher Iliffe Sprague
// christopher.iliffe.sprague@gmail.com

#include "dynamics.hpp"
#include <pybind11/numpy.h>
namespace py = pybind11;

namespace dynamics {

  struct simple_spacecraft {

    // constants
    const double c1, c2;

    // constructor
    simple_spacecraft (const double & T_, const double & Isp_, const double & g0_) : c1(T_), c2(Isp_*g0). g0(g0_) {};

    // destructor
    ~simple_spacecraft (void) {};

    // state equations of motion (SEOM)
    const py::array_t<double> & eom_state (
      const py::array_t<double, py::array::forcecast> & state_,
      const py::array_t<double, py::array::forcecast> & control_
    ) const {



    };

    // SEOM Jacobian (SEOMJ)
    virtual const py::array_t<double> & eom_state_jac (
      const py::array_t<double, py::array::forcecast> & state_,
      const py::array_t<double, py::array::forcecast> & control_
    ) const {};

    // fullstate equations of motion (FSEOM)
    virtual const py::array_t<double> & eom_fullstate (
      const py::array_t<double, py::array::forcecast> & fullstate_,
      const py::array_t<double, py::array::forcecast> & control_
    ) const {};

    // FSEOM Jacobian (FSEOMJ)
    virtual const py::array_t<double> & eom_fullstate_jac (
      const py::array_t<double, py::array::forcecast> & fullstate_,
      const py::array_t<double, py::array::forcecast> & control_
    ) const {};

    // Lagrangian
    virtual const double & lagrangian (
      const py::array_t<double, py::array::forcecast> & control_
    ) const {};

    // Hamiltonian
    virtual const double & hamiltonian (
      const py::array_t<double, py::array::forcecast> & fullstate_,
      const py::array_t<double, py::array::forcecast> & control_
    ) const {};

    // Pontryagin
    virtual const py::array_t<double> & pontryagin (
      const py::array_t<double, py::array::forcecast> & fullstate_
    ) const {};

  };



  }

}
