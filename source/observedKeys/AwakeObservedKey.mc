import Toybox.Lang;
import Toybox.WatchUi;
import ObservedStore;
import Services;
import Services.ServiceType;
import SensorInfoModule.SensorType;

class AwakeObservedKey extends ObservedStore.KeyInstance {
    public static var key = "AwakeObservedKey";
    public var scope as Array<ObservedStore.Scope> = [
        ObservedStore.Scope.ON_UPDATE,
        ObservedStore.Scope.ON_PARTIAL_UPDATE,
        ObservedStore.Scope.ON_NIGHT_MODE_CHANGED,
    ];

    private var _isAwake as Boolean;
    private var _mainView as WatchUi.View;

    function initialize(mainView as WatchUi.View, isAwake as Boolean) {
        self._mainView = mainView;
        self._isAwake = isAwake;

        ObservedStore.KeyInstance.initialize();
    }

    function setIsAwake(isAwake as Boolean) as Void {
        self._isAwake = isAwake;
    }

    function get() as Lang.Object? {
        var service = Services.get(ServiceType.SENSORS_INFO);
        var isNightMode = service.getValue(SensorType.IS_NIGHT_MODE_ENABLED);
        var isSleepTime = service.getValue(SensorType.IS_SLEEP_TIME);

        return isNightMode == true || isSleepTime == true ? false : self._isAwake;
    }

    private function updateViewProps(isAwake as Boolean) as Void {
        var secondsViewID = $.VIEWS_LIST.get(:seconds);
        var secondsView = self._mainView.findDrawableById(secondsViewID) as SecondsView;
        var displaySecondsType = Services.get(ServiceType.OBSERVED_STORE).getValue(DisplaySecondsObservedKey);

        secondsView.setViewProps(displaySecondsType, isAwake);
    }

    function onValueInit(value) as Void {
        self.updateViewProps(value);
    }

    function onValueUpdated(value as Boolean, prevValue as Boolean) as Void {
        self.updateViewProps(value);
    }
}
