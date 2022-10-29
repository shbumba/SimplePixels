import Toybox.Lang;
import Toybox.Application;
import Toybox.WatchUi;

class SimplePixelsApp extends Application.AppBase {
    private var mainView as SimplePixelsView;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {}

    function onStop(state as Dictionary?) as Void {}

    function getInitialView() as Array<Views or InputDelegates>? {
        self.mainView = new SimplePixelsView();

        return [self.mainView];
    }

    function getSettingsView() as Array<Views or InputDelegates>? {
        var onSettingsChanged = new Lang.Method(self, :onSettingsChanged);

        return [new WatchSettingsView(onSettingsChanged)];
    }
    
    function onSettingsChanged() as Void {
        self.mainView.onSettingsChanged();
    }

    function onNightModeChanged() as Void {
        self.mainView.onNightModeChanged();
    }

}
