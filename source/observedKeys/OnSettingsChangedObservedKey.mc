import Toybox.Lang;
import Toybox.WatchUi;
import ObservedStore;

typedef OnSettingsChangedObservedKeyProps as {
    :mainView as WatchUi.View
};

class OnSettingsChangedObservedKey extends ObservedStore.KeyInstance {
    public static var key = "OnSettingsChangedObservedKey";
    public var scope as Array<ObservedStore.Scope> = [
        ObservedStore.Scope.ON_SETTINGS_CHANGED
    ];

    private var _mainView as WatchUi.View;

    function initialize(mainView as WatchUi.View) {
        self._mainView = mainView;

        ObservedStore.KeyInstance.initialize();
    }

    function get() as Lang.Object? {
        return System.getClockTime().sec;
    }

    function onValueUpdated(props as ValueUpdatedProps) as Void {
        var viewValues = $.VIEWS_LIST.values();

        for (var i = 0; i < viewValues.size(); i++) {
            var view = self._mainView.findDrawableById(viewValues[i]);

            view.onSettingsChanged();
        }
    }
}
