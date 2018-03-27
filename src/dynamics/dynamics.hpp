// Christopher Iliffe Sprague
// christopher.iliffe.sprague@gmail.com

#ifndef dynamics_hpp
#define dynamics_hpp

namespace dynamics {

  struct base {

    // state and actions space dimensions
    const unsigned short int sdim, adim;

    // constructor
    base (const unsigned short int & sdim_, const unsigned short int & adim_) : sdim(sdim_), adim(adim_) {};

    // destructor
    ~base (void) {};

  };

};

#endif
