#include "animate.h"
#include "../gui.h"

animate::animate(int max_health) {
  _max_health = max_health;
  _health = _max_health;
}

string animate::get_health_string() {
  return _health + "/" + _max_health;
}

void attacked_by(animate *opponent) {
  if (debug) printf("attacking");

}
