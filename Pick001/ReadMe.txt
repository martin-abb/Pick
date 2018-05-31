Notes on move time analysis
Martin Krucinski
05/31/2018

Main parameters:
----------------

Move distance           dx = x2 - x1
Max velocity            v_max
Max collision velocity  v_coll
Max acceleration/decel  a_max
Uncertainties           delta_1, delta_2 (at source, at destination)

Main sensitivity to analyze is due to the delta_1 & delta_2

Total move time:

Accel time
Move time
Decel part 1 time
Move time at v_coll safe velocity
Decel part 2
Pick up object: close jaw & build up grip force or build up vacuum force
Accel time
Move time (possibly this has to be in 2 parts: accel up to v_coll,
travel time in congested area, accel up to v_max)
Decel time (possibly two parts if congested item drop-off area)
open jaw (decrease grip force to zero) or remove vacuum force
