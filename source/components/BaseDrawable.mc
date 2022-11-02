import Toybox.Lang;
import Toybox.WatchUi;
import ColorsModule;
import SettingsModule;
import SettingsModule.SettingType;

module Component {
    class BaseDrawable extends WatchUi.Drawable {        
        protected var backgroundColor as Number;
        protected var foregroundColor as Number;
        protected var textColor as Number;

        function initialize(params) {
            Drawable.initialize(params);

            self.onSettingsChanged();
        }

        public function onSettingsChanged() {
            self.backgroundColor = ColorsModule.getColor(SettingsModule.getValue(SettingType.BACKGROUND_COLOR));
            self.foregroundColor = ColorsModule.getColor(SettingsModule.getValue(SettingType.FOREGROUND_COLOR));
            self.textColor = ColorsModule.getColor(SettingsModule.getValue(SettingType.TEXT_COLOR));
        }
    }
}