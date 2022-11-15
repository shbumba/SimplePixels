import Toybox.Lang;
import Toybox.WatchUi;
import WatcherModule;
import Services;
import SettingsModule;

class DisplaySecondsWatcher extends WatcherModule.Watcher {
    public static var key as String = "DisplaySecondsWatcher";
    public var scope as Array<Scope> = [WatcherModule.ON_SETTINGS_CHANGED] as Array<Scope>;

    private var _mainView as WatchUi.View;

    function initialize(mainView as WatchUi.View) {
        WatcherModule.Watcher.initialize();

        self._mainView = mainView;
    }

    function get() as Lang.Object? {
        return SettingsModule.getValue(SettingsModule.SettingType.DISPLAY_SECONDS);
    }

    private function updateViewProps(value as InstanceGetter) as Void {
        var displaySecondsType = value as DisplaySecondsType.Enum;
        var secondsViewID = $.VIEWS_LIST.get(:seconds);
        var secondsView = self._mainView.findDrawableById(secondsViewID) as SecondsView;
        var isAwake = Services.WathersStore().getValue(AwakeWatcher) as Boolean;

        secondsView.setViewProps(displaySecondsType, isAwake);
    }

    function onValueInit(value as InstanceGetter) as Void {
        self.updateViewProps(value);
    }

    function onValueUpdated(value as InstanceGetter, prevValue as InstanceGetter) as Void {
        self.updateViewProps(value);
    }
}
