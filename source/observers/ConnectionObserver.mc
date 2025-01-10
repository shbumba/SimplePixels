import Toybox.Lang;
import ObserverModule;
import SettingsModule;

class ConnectionObserverObserver extends ObserverModule.ValueObserver {
    static var key as InstanceKey = :connectionObserver;
    var scope as Array<Scope> = [
        ObserverModule.ON_UPDATE,
        ObserverModule.ON_PARTIAL_UPDATE,
    ];

    function initialize(onValueUpdated as Method?) {
        ObserverModule.ValueObserver.initialize(onValueUpdated);
    }

    function getObservedValue() as InstanceGetter {
        return System.getDeviceSettings().connectionAvailable;
    }

    function onValueInit(value as InstanceGetter, prevValue as Null) as Void {
        // Do nothing
    }
}
