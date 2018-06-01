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

Start at destination location
Accel time
Move time
In time window when gripper leaves source area, and before it returns and re-enters,
acquire sensor data & run perception pipeline.
Decel part 1 time
Move time at v_coll safe velocity
Decel part 2
Pick up object: close jaw & build up grip force or build up vacuum force
Accel time
Move time (possibly this has to be in 2 parts: accel up to v_coll,
travel time in congested area, accel up to v_max)
Remainig items re-settling time
Decel time (possibly two parts if congested item drop-off area)
open jaw (decrease grip force to zero) or remove vacuum force

With regards to specific robot parameters (v_max, a_max),
need to evaluate using max joint velocity and max extension of joint axes 2 & 3.

Verify by running simulation in RobotStudio and logging tool velocities & accelerations
as well as joint velocities & accelerations

