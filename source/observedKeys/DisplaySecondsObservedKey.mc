import Toybox.Lang;
import Toybox.WatchUi;
import ObservedStore;
import Services;
import Services.ServiceType;
import SettingsModule;

class DisplaySecondsObservedKey extends ObservedStore.KeyInstance {
    public static var key = "DisplaySecondsObservedKey";
    public var scope as Array<ObservedStore.Scope> = [
        ObservedStore.Scope.ON_SETTINGS_CHANGED
    ];

    private var _mainView as WatchUi.View;

    function initialize(mainView as WatchUi.View) {
        self._mainView = mainView;

        ObservedStore.KeyInstance.initialize();
    }

    function get() as Lang.Object? {
        return SettingsModule.getValue(SettingsModule.SettingType.DISPLAY_SECONDS);
    }

    private function updateViewProps(displaySecondsType as DisplaySecondsType) as Void {
        var secondsViewID = $.VIEWS_LIST.get(:seconds);
        var secondsView = self._mainView.findDrawableById(secondsViewID) as SecondsView;
        var isAwake = Services.get(ServiceType.OBSERVED_STORE).getValue(AwakeObservedKey);

        secondsView.setViewProps(displaySecondsType, isAwake);
    }

    function onValueInit(value as DisplaySecondsType) as Void {
        self.updateViewProps(value);
    }

    function onValueUpdated(value as DisplaySecondsType, prevValue as DisplaySecondsType) as Void {
        self.updateViewProps(value);
    }
}
