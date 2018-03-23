// Christopher Iliffe Sprague
// christopher.iliffe.sprague@gmail.com

#ifdef auv_hpp
#define auv_hpp

#include "dynamical_system.hpp"

struct auv : public dynamical_system {

  // constructor
  auv (const unsigned short int & sdim_, const unsigned short int & adim_) : dynamical_system(sdim, adim) {};

  // destructor
  ~auv (void) {};

};

#endif
