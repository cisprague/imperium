// Christopher Iliffe Sprague
// christopher.iliffe.sprague@gmail.com

#ifdef auv_cylinder_tv_2d_hpp
#define auv_cylinder_tv_2d_hpp

#include "dynamical_system.hpp"

struct auv_cylinder_tv_2d : public dynamical_system {

  // constructor
  auv (const unsigned short int & sdim_, const unsigned short int & adim_) : dynamical_system(sdim, adim) {};

  // destructor
  ~auv (void) {};

};

#endif
