// Christopher Iliffe Sprague
// christopher.iliffe.sprague@gmail.com

#ifndef dynamical_system_hpp
#define dynamical_system_hpp

#include <vector>
#include <cmath>

namespace Imperium {

  struct Dynamical_System {

    // state and actions space dimensions
    const int sdim, adim;

    // constructor
    Dynamical_System (const int & sdim_, const int & adim_) : sdim(sdim_), adim(adim_) {};

    // destructor
    ~Dynamical_System (void) {};

    // get state dimensions
    const int & get_sdim (void) const {
      return sdim;
    };


  };

};

#endif
