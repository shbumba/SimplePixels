import Toybox.Lang;
import Toybox.Application;
import Toybox.WatchUi;

class SimplePixelsApp extends Application.AppBase {
    private var mainView as SimplePixelsView or Null = null;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {}

    function onStop(state as Dictionary?) as Void {}

    function getInitialView() as Array<Views or InputDelegates>? {
        self.mainView = new SimplePixelsView();

        return [self.mainView] as Array<Views or InputDelegates>;
    }

    function getSettingsView() as Array<Views or InputDelegates>? {
        var onSettingsChanged = new Lang.Method(self, :onSettingsChanged);

        return [new SettingsMenuView(onSettingsChanged)] as Array<Views or InputDelegates>;
    }
    
    function onSettingsChanged() as Void {
        if (self.mainView != null) {
            self.mainView.onSettingsChanged();
        }
    }

    function onNightModeChanged() as Void {
        if (self.mainView != null) {
            self.mainView.onNightModeChanged();
        }
    }

}
