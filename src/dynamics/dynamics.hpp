// Christopher Iliffe Sprague
// christopher.iliffe.sprague@gmail.com

#pragma once
#include <pybind11/numpy.h>
namespace py = pybind11;

namespace dynamics {

  struct base {

    // state and actions space dimensions
    const unsigned short int sdim, adim;

    // constructor
    base (const unsigned short int & sdim_, const unsigned short int & adim_) : sdim(sdim_), adim(adim_) {};

    // destructor
    ~base (void) {};

    // state equations of motion (SEOM)
    virtual const py::array_t<double> & eom_state (
      const py::array_t<double, py::array::forcecast> & state_,
      const py::array_t<double, py::array::forcecast> & control_
    ) const {};

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

    // lagrangian
    virtual const double & lagrangian (
      const py::array_t<double, py::array::forcecast> & control_
    ) const {};

    // hamiltonian
    virtual const double & hamiltonian (
      const py::array_t<double, py::array::forcecast> & fullstate_,
      const py::array_t<double, py::array::forcecast> & control_
    ) const {};

    virtual const py::array_t<double> & pontryagin (
      const py::array_t<double, py::array::forcecast> & fullstate_
    ) const {};

  };

};
