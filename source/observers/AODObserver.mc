import Toybox.Lang;
import Toybox.System;
import ObserverModule;
import Services;
import SensorTypes;

class AODObserver extends ObserverModule.ValueObserver {
    static var key as InstanceKey = :aodObserver;

    var scope as Array<Scope> = [ObserverModule.ON_ENTER_SLEEP, ObserverModule.ON_EXIT_SLEEP];

    function initialize(onValueUpdated as Method?) {
        ObserverModule.ValueObserver.initialize(onValueUpdated);
    }

    function getObservedValue() as InstanceGetter {
        return System has :getDisplayMode
            ? System.getDisplayMode() == System.DISPLAY_MODE_LOW_POWER
                ? true
                : false
            : null;
    }
}
