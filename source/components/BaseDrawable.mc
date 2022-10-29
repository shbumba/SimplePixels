import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import ColorsModule;
import SettingsModule;
import SettingsModule.SettingType;

module Component {
    class BaseDrawable extends WatchUi.Drawable {        
        protected var deviceWidth as Number;
        protected var deviceHeight as Number;
        protected var backgroundColor as Number;
        protected var foregroundColor as Number;
        protected var textColor as Number;

        function initialize(params as Dictionary<String, String or Null>) {
            Drawable.initialize(params);

            var deviceSettings = System.getDeviceSettings();

            self.deviceWidth = deviceSettings.screenWidth;
            self.deviceHeight = deviceSettings.screenHeight;

            self.onSettingsChanged();
        }

        public function onSettingsChanged() {
            self.backgroundColor = ColorsModule.getColor(SettingsModule.getValue(SettingType.BACKGROUND_COLOR));
            self.foregroundColor = ColorsModule.getColor(SettingsModule.getValue(SettingType.FOREGROUND_COLOR));
            self.textColor = ColorsModule.getColor(SettingsModule.getValue(SettingType.TEXT_COLOR));
        }
    }
}