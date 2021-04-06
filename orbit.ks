//Inspired by https://github.com/xeger/kos-ramp

function countdown {
    print "Counting down:".
    from {local tick is 10.} until tick = 0 step {set tick to tick - 1.} do {
        print "..." + tick + " " at (15, 0).
        wait 1. // pauses the script here for 1 second.
    }
}

function launch_burn {
    lock throttle to 1.
    set apoapsisGoal to 80000.
    print "Apoapsis goal: " + apoapsisGoal + " | Current: ".
    until apoapsis > 80000 {
        
        print round(apoapsis,0) at (32, 1).

        if velocity:surface:mag < 100 {
            lock steering to heading(90, 90, 0).
        }
        else if velocity:surface:mag < 200 {
            lock steering to heading(90, 80, 0).
            lock throttle to 0.67.
        }
        else if altitude < 10000 {
            unlock steering. // Gravity turn
        }
        else
        {
            lock steering to heading(90, 45, 0).
        }
    }
    print "Apoapsis reached, cutting throttle".
    lock throttle to 0.
    lock steering to prograde.
}


function compute_orbiting_node {
    print "Computing orbiting manoeuvre node".

    parameter desiredPeriapsis.

    // present orbit properties
    local vom is velocity:orbit:mag. // actual velocity
    local r is body:radius + altitude. // actual distance to body
    local ra is body:radius + apoapsis. // radius at apoapsis
    local va is sqrt( vom^2 + 2*body:mu*(1/ra - 1/r) ). // velocity at apoapsis
    local sma is (periapsis + 2*body:radius + apoapsis)/2. // semi major axis

    // future orbit properties
    local desiredSma is (desiredPeriapsis + 2*body:radius + apoapsis)/2. // semi major axis target orbit
    local desiredVa is sqrt( vom^2 + (body:mu * (2/ra - 2/r + 1/sma - 1/desiredSma ) ) ).

    // create node
    local deltav is desiredVa - va.
    return node(time:seconds + eta:apoapsis, 0, 0, deltav).
}
