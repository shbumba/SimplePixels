import Toybox.Lang;
import Toybox.WatchUi;
import WatcherModule;
import Services;
import SettingsModule;
import SensorTypes;
import ViewsKeys;

class AwakeWatcher extends WatcherModule.Watcher {
    static var key as String = "AwakeWatcher";
    static var isAwake as Boolean;

    var scope as Array<Scope> = [
        WatcherModule.ON_UPDATE,
        WatcherModule.ON_PARTIAL_UPDATE,
        WatcherModule.ON_NIGHT_MODE_CHANGED,
        WatcherModule.ON_ENTER_SLEEP,
        WatcherModule.ON_EXIT_SLEEP
    ];

    var _mainView as WatchUi.View;

    function initialize(mainView as WatchUi.View, isAwake as Boolean) {
        WatcherModule.Watcher.initialize();

        self._mainView = mainView;
        self.isAwake = isAwake;
    }

    function get() as Lang.Object? {
        var service = Services.SensorInfo();
        var isNightMode = service.getValue(SensorTypes.IS_NIGHT_MODE_ENABLED);
        var isSleepTime = service.getValue(SensorTypes.IS_SLEEP_TIME);

        return isNightMode == true || isSleepTime == true ? false : self.isAwake;
    }

    function _updateViewProps(value as InstanceGetter) as Void {
        var isAwake = value as Boolean;
        var secondsView = self._mainView.findDrawableById(ViewsKeys.SECONDS) as SecondsView;
        var displaySecondsType = Services.WathersStore().getValue(DisplaySecondsWatcher.key) as DisplaySecondsType.Enum;

        secondsView.setViewProps(displaySecondsType, isAwake);
        WatchUi.requestUpdate();
    }

    function onValueInit(value as InstanceGetter) as Void {
        self._updateViewProps(value);
    }

    function onValueUpdated(value as InstanceGetter, prevValue as InstanceGetter) as Void {
        self._updateViewProps(value);
    }
}
