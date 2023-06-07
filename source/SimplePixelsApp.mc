import Toybox.Lang;
import Toybox.Application;
import Toybox.WatchUi;
import Toybox.System;
import StoreKeys;

(:background)
class SimplePixelsApp extends Application.AppBase {
    var _mainView as SimplePixelsView or Null = null;
    (:background)
    var _bgController = new BackgroundController();

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() as Array<Views or InputDelegates>? {
        self._bgController.setup();

        self._mainView = new SimplePixelsView();

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
            self._bgController.setup();
            self._mainView.onSettingsChanged();
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


        self._bgController.next();
	}
}
