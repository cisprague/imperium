// Christopher Iliffe Sprague
// christopher.iliffe.sprague@gmail.com

#ifndef imperium_hpp
#define imperium_hpp

#include <pybind11/pybind11.h>
namespace py = pybind11;

#include "dynamical_system.hpp"

PYBIND11_MODULE(imperium, m) {

  py::class_<Imperium::Dynamical_System>(m, "Dynamical_System")
    .def(py::init<const int &, const int &>())
    .def("get_sdim", & Imperium::Dynamical_System::get_sdim);

};

#endif
