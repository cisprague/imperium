// Christopher Iliffe Sprague
// christopher.iliffe.sprague@gmail.com

#pragma once
#include "dynamics/dynamics.hpp"
#include "dynamics/auv_cylinder_tv_2d.hpp"
#include <pybind11/pybind11.h>
namespace py = pybind11;

PYBIND11_MODULE(imperium, m) {

  // submodules
  py::module m1(m.def_submodule("dynamics"));

  py::class_<dynamics::base>(m1, "base")
    .def(py::init<const unsigned short int &, const unsigned short int &>())
    .def_readonly("sdim", & dynamics::base::sdim)
    .def_readonly("adim", & dynamics::base::adim)
    .def("eom_state", & dynamics::base::eom_state);

  py::class_<dynamics::auv_cylinder_tv_2d, dynamics::base>(m1, "auv_cylinder_tv_2d")
    .def(py::init<const unsigned short int &, const unsigned short int &>());

};
