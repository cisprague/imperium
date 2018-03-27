// Christopher Iliffe Sprague
// christopher.iliffe.sprague@gmail.com

#ifndef imperium_hpp
#define imperium_hpp

#include "dynamics/dynamics.hpp"

#include <pybind11/pybind11.h>
namespace py = pybind11;

// modules
py::module m("imperium");
py::module m1(m.def_submodule("dynamics"));

// dynamical model


/*
PYBIND11_MODULE(dynamics, m) {

  py::class_<dynamics::base>(m, "base")
    .def(py::init<const unsigned short int &, const unsigned short int &>())
    .def_readonly("sdim", & dynamics::base::sdim)
    .def_readonly("adim", & dynamics::base::adim);

};
*/

#endif
