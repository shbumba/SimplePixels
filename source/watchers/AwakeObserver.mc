import Toybox.Lang;
import ObserverModule;
import Services;
import SensorTypes;

class AwakeObserver extends ObserverModule.ValueObserver {
    static var key as InstanceKey = :awakeObserver;
    static var isAwake as Boolean;

    var scope as Array<Scope> = [
        ObserverModule.ON_UPDATE,
        ObserverModule.ON_PARTIAL_UPDATE,
        ObserverModule.ON_NIGHT_MODE_CHANGED,
        ObserverModule.ON_ENTER_SLEEP,
        ObserverModule.ON_EXIT_SLEEP
    ];

    function initialize(onValueUpdated as Method?, isAwake as Boolean) {
        ObserverModule.ValueObserver.initialize(onValueUpdated);

        self.isAwake = isAwake;
    }

    function getObservedValue() as InstanceGetter {
        var service = Services.SensorInfo();
        var isNightMode = service.getValue(SensorTypes.IS_NIGHT_MODE_ENABLED);
        var isSleepTime = service.getValue(SensorTypes.IS_SLEEP_TIME);

        return isNightMode == true || isSleepTime == true ? false : self.isAwake;
    }
}
