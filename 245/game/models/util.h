#ifndef UTIL_H
#define UTIL_H

#include <sstream>

//notfaq.wordpress.com/2006/08/30/c-convert-int-to-string
template<typename T>
inline std::string to_string(const T& t) {
  std::stringstream ss;
  ss << t;
  return ss.str();
}

#endif
