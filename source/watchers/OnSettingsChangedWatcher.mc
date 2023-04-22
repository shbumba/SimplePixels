import Toybox.Lang;
import Toybox.WatchUi;
import WatcherModule;
import Components;

class OnSettingsChangedWatcher extends WatcherModule.Watcher {
    public static var key as String = "OnSettingsChangedWatcher";
    public var scope as Array<Scope> = [WatcherModule.ON_SETTINGS_CHANGED] as Array<Scope>;

    private var _mainView as WatchUi.View;

    function initialize(mainView as WatchUi.View) {
        WatcherModule.Watcher.initialize();

        self._mainView = mainView;
    }

    function get() as Lang.Object? {
        return System.getClockTime().sec;
    }

    function onValueUpdated(value as InstanceGetter, prevValue as InstanceGetter) as Void {
        var viewValues = $.VIEWS_LIST.values();

        for (var i = 0; i < viewValues.size(); i++) {
            var id = viewValues[i] as String;
            var view = self._mainView.findDrawableById(id);

            (view as Components.BaseDrawable).onSettingsChanged();
        }

        WatchUi.requestUpdate();
    }
}
