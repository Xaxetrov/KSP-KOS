// functions
copyPath("0:/node.ks", "1:/node.ks").
copyPath("0:/orbit.ks", "1:/orbit.ks").
copyPath("0:/stage.ks", "1:/stage.ks").
runOncePath("1:/node.ks").
runOncePath("1:/orbit.ks").
runOncePath("1:/stage.ks").

clearscreen.

// Staging trigger
set burnStages to 3.
when burnStages > 0 and stage_check() then {
    print "Staging".
    stage.
    set burnStages to burnStages - 1.
    return burnStages > 0.
}.

countdown().

launch_burn().

print "Locking steering to surface prograde".
lock steering to srfPrograde.

wait until altitude > 70000.

add compute_orbiting_node(80000).

perform_node().

//set throttle to 0 just in case.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

