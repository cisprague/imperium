cmake_minimum_required(VERSION 2.8.12)
project(Imperium)
find_package(pybind11 REQUIRED)

# source
pybind11_add_module(Imperium src/imperium.hpp)
