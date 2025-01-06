import Toybox.Lang;
import Toybox.Application;
import Toybox.WatchUi;
import Toybox.System;
import StoreKeys;

(:background)
class SimplePixelsApp extends Application.AppBase {
    var _mainView as SimplePixelsView or Null = null;

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() as [ Views ] or [ Views, InputDelegates ] {
        self._mainView = new SimplePixelsView();

        OWBackgroundController.setup();

        return [self._mainView];
    }

    function getSettingsView() as [ Views ] or [ Views, InputDelegates ] or Null  {
        return [new SettingsMenuView(self.method(:onSettingsChanged) as Method)];
    }

    function getServiceDelegate() as [ System.ServiceDelegate ] {
        return [new BackgroundServiceDelegate()];
    }
    
    function onSettingsChanged() as Void {
        if (self._mainView != null) {
            self._mainView.onSettingsChanged();
        }

        OWBackgroundController.setup();
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

        if (needToRerun) {
            OWBackgroundController.runNow();
        } else {
            OWBackgroundController.scheduleNext();
        }
	}
}
