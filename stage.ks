function stage_check {	//a check for if the rocket needs to stage
	local needStage is false.
    local engineList is list().
    list engines in engineList.
    if maxthrust = 0 and throttle > 0 {
        set needStage to true.
    } else {
        for engine in engineList {
            if engine:ignition and engine:flameout {
                set needStage to true.
                break.
            }
        }
    }
	return needStage.
}

function verbose_stage_check {	//a check for if the rocket needs to stage
	local needStage is false.
    local engineList is list().
    list engines in engineList.
    print engineList.
    if maxthrust = 0 and throttle > 0 {
        set needStage to true.
    } else {
        for engine in engineList {
            print "Ignition " + engine:ignition + " Flameout " + engine:flameout.
            if engine:ignition and engine:flameout {
                set needStage to true.
                break.
            }
        }
    }
	return needStage.
}