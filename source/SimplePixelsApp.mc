import Toybox.Lang;
import Toybox.Application;
import Toybox.WatchUi;
import Toybox.System;
import StoreKeys;

(:background)
class SimplePixelsApp extends Application.AppBase {
    var _mainView as SimplePixelsView or Null = null;
    var _bgController as BackgroundController or Null = null;

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() as Array<Views or InputDelegates>? {
        self._bgController = new BackgroundController();
        self._mainView = new SimplePixelsView();

        self._bgController.setup();

        return [self._mainView] as Array<Views or InputDelegates>;
    }

    function getSettingsView() as Array<Views or InputDelegates>? {
        return [new SettingsMenuView(self.method(:onSettingsChanged) as Method)] as Array<Views or InputDelegates>;
    }

    function getServiceDelegate() as Array<System.ServiceDelegate> {
        return [new BackgroundService()];
    }
    
    function onSettingsChanged() as Void {
        if (self._mainView != null) {
            self._mainView.onSettingsChanged();
        }

        if (self._bgController != null) {
            self._bgController.setup();
        }
    }

    function onNightModeChanged() as Void {
        if (self._mainView != null) {
            self._mainView.onNightModeChanged();
        }
    }

    function onBackgroundData(data as Application.PersistableType) as Void {
        if ((data instanceof Dictionary) && data.hasKey(StoreKeys.OPENWEATHER_DATA)) {
            Storage.setValue(StoreKeys.OPENWEATHER_DATA, data[StoreKeys.OPENWEATHER_DATA]);
        }

        if (self._bgController != null) {
            self._bgController.next();
        }
	}
}
