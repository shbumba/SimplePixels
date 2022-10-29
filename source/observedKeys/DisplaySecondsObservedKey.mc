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

    private function updateViewProps(props as ValueUpdatedProps or ValueItinProps) as Void {
        var displaySecondsType = props.get(:value);

        var secondsViewID = $.VIEWS_LIST.get(:seconds);
        var secondsView = self._mainView.findDrawableById(secondsViewID) as SecondsView;
        var isAwake = Services.get(ServiceType.OBSERVED_STORE).getValue(AwakeObservedKey);

        secondsView.setViewProps({
            :displaySecondsType => displaySecondsType,
            :isAwake => isAwake
        });
    }

    function onValueInit(props as ValueItinProps) as Void {
        self.updateViewProps(props);
    }

    function onValueUpdated(props as ValueUpdatedProps) as Void {
        self.updateViewProps(props);
    }
}
