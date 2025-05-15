import Toybox.Lang;
import Toybox.WatchUi;
import ColorsModule;
import SettingsModule;
import SettingsModule.SettingType;

module Components {
    class BaseDrawable extends WatchUi.Drawable {
        protected var backgroundColor as Number = 0;
        protected var foregroundColor as Number = 0;
        protected var infoColor as Number = 0;
        protected var aodColor as Number = 0;
        protected var isAod as Boolean = false;

        function initialize(params) {
            self.setColors();

            Drawable.initialize(params);
        }

        function setColors() as Void {
            self.backgroundColor = getSettingColor(SettingType.BACKGROUND_COLOR);
            self.foregroundColor = getSettingColor(SettingType.FOREGROUND_COLOR);
            self.infoColor = getSettingColor(SettingType.INFO_COLOR);
            self.aodColor = Graphics.COLOR_DK_GRAY;
        }

        function onSettingsChanged() as Void {
            self.setColors();
        }

        function setAodMode(isAod as Boolean) as Void {
            self.isAod = isAod;
        }
    }
}
