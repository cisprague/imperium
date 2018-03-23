// Christopher Iliffe Sprague
// christopher.iliffe.sprague@gmail.com

#ifndef imperium_hpp
#define imperium_hpp

#include "dynamical_system.hpp"
#include "auv.hpp"

#include <pybind11/pybind11.h>
namespace py = pybind11;

PYBIND11_MODULE(imperium, m) {

  py::class_<dynamical_system>(m, "dynamical_system")
    .def(py::init<const unsigned short int &, const unsigned short int &>())
    .def_readonly("sdim", & dynamical_system::sdim)
    .def_readonly("adim", & dynamical_system::adim);

  py::class_<auv>(m, "auv")
    .def(py::init<const unsigned short int &, const unsigned short int &>());

};

#endif
