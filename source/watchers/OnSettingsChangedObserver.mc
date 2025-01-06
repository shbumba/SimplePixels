import Toybox.Lang;
import ObserverModule;

class OnSettingsChangedObserver extends ObserverModule.ValueObserver {
    static var key as InstanceKey = :onSettingsChangedObserver;
    var scope as Array<Scope> = [ObserverModule.ON_SETTINGS_CHANGED];

    function initialize(onValueUpdated as Method?) {
        ObserverModule.ValueObserver.initialize(onValueUpdated);
    }

    function getObservedValue() as InstanceGetter {
        return System.getClockTime().sec;
    }

    function onValueInit(value as InstanceGetter, prevValue as Null) as Void {
        // Do nothing
    }
}
