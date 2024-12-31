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

    function getInitialView() as [ Views ] or [ Views, InputDelegates ] {
        self._bgController = new BackgroundController();
        self._mainView = new SimplePixelsView();

        self._bgController.setup();

        return [self._mainView];
    }

    function getSettingsView() as [ Views ] or [ Views, InputDelegates ] or Null  {
        return [new SettingsMenuView(self.method(:onSettingsChanged) as Method)];
    }

    function getServiceDelegate() as [ System.ServiceDelegate ] {
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
        var needToRerun = false;
        
        if ((data instanceof Dictionary) && data.hasKey(StoreKeys.OW_DATA)) {
            var prevData = Storage.getValue(StoreKeys.OW_DATA) as Dictionary<PropertyKeyType, PropertyValueType> or Null;
            var newData = data[StoreKeys.OW_DATA] as Dictionary<PropertyKeyType, PropertyValueType>;

            if (prevData != null) {
                newData = combineDictionaries(prevData, newData);
            }

            Storage.setValue(StoreKeys.OW_DATA, newData);

            needToRerun = !!newData.get("hasError");
        }

        if (self._bgController == null) {
            return;
        }

        if (needToRerun) {
            self._bgController.runNow();
        } else {
            self._bgController.scheduleNext();
        }
	}
}
