import Toybox.Lang;
import SettingsModule.SettingType;
import SettingsModule;

(:background)
class OWBackgroundControllerImpl extends BackgroundController {
    function initialize() {
        BackgroundController.initialize();
    }

    protected function getInterval() as Number {
        var intervalMinutes = SettingsModule.getValue(SettingType.OW_INTERVAL);

        return intervalMinutes != null ? intervalMinutes : 30;
    }

    protected function isEnabled() as Boolean {
        return !!SettingsModule.getValue(SettingType.OW_ENABLED) && System.getDeviceSettings().connectionAvailable;
    }
}

(:background)
var OWBackgroundController = new OWBackgroundControllerImpl();