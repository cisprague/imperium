// Christopher Iliffe Sprague
// christopher.iliffe.sprague@gmail.com

#ifndef dynamical_system_hpp
#define dynamical_system_hpp


struct dynamical_system {

  // state and actions space dimensions
  const unsigned short int sdim, adim;

  // constructor
  dynamical_system (const unsigned short int & sdim_, const unsigned short int & adim_) : sdim(sdim_), adim(adim_) {};

  // destructor
  ~dynamical_system (void) {};

};

#endif
