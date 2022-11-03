import Toybox.Lang;
import Toybox.WatchUi;
import ObservedStoreModule;
import ObservedStoreModule.Scope;

class OnSettingsChangedObservedKey extends ObservedStoreModule.KeyInstance {
    public static var key as String = "OnSettingsChangedObservedKey";
    public var scope as Array<Scope.Enum> = [
        Scope.ON_SETTINGS_CHANGED
    ] as Array<Scope.Enum>;

    private var _mainView as WatchUi.View;

    function initialize(mainView as WatchUi.View) {
        ObservedStoreModule.KeyInstance.initialize();

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

            (view as Component.BaseDrawable).onSettingsChanged();
        }
    }
}
