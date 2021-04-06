function perform_node {	//a check for if the rocket needs to stage
    print"Locking steering to maneuver node".
    lock steering to nextNode:burnvector.

    print "Node in: " + round(nextNode:eta) + ", DeltaV: " + round(nextNode:deltav:mag).
    set max_acc to ship:maxthrust/ship:mass.
    set burn_duration to nextNode:deltav:mag/max_acc.
    print "Estimated burn duration: " + round(burn_duration) + "s".

    wait until nextNode:eta <= (burn_duration/2).

    set tset to 0.
    lock throttle to tset.

    set done to False.
    set dv0 to nextNode:deltav. //initial deltav
    until done
    {
        // Recalculate current max_acceleration, as it changes while we burn through fuel
        set max_acc to ship:maxthrust/ship:mass.

        // Throttle is 100% until there is less than 1 second of time left to burn
        // When there is less than 1 second - decrease the throttle linearly
        set tset to min(nextNode:deltav:mag/max_acc, 1).

        // We need to cut the throttle as soon as our nd:deltav and initial deltav start facing opposite directions
        // This check is done via checking the dot product of those 2 vectors
        if vdot(dv0, nextNode:deltav) < 0
        {
            print "End burn, remain dv " + round(nextNode:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nextNode:deltav),1).
            lock throttle to 0.
            break.
        }

        // We have very little left to burn, less then 0.1m/s
        if nextNode:deltav:mag < 0.1
        {
            print "Finalizing burn, remain dv " + round(nextNode:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nextNode:deltav),1).
            // We burn slowly until our node vector starts to drift significantly from initial vector
            // This usually means we are on point
            wait until vdot(dv0, nextNode:deltav) < 0.5.

            lock throttle to 0.
            print "End burn, remain dv " + round(nextNode:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nextNode:deltav),1).
            set done to True.
        }
    }
    unlock steering.
    unlock throttle.
    wait 1.

    remove nextNode.
}