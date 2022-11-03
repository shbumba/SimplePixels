import Toybox.Lang;
import Toybox.Application.Properties;

module SettingsModule {
    module SettingType {
        enum Enum {
            BACKGROUND_COLOR = "BackgroundColor",
            FOREGROUND_COLOR = "ForegroundColor",
            TEXT_COLOR = "TextColor",
            SEPARATOR_COLOR = "SeparatorColor",
            SEPARATOR_INFO = "SeparatorInfo",
            TOP_SENSOR_1 = "TopSensor1",
            TOP_SENSOR_2 = "TopSensor2",
            TOP_SENSOR_3 = "TopSensor3",
            BOTTOM_SENSOR_1 = "BottomSensor1",
            BOTTOM_SENSOR_2 = "BottomSensor2",
            BOTTOM_SENSOR_3 = "BottomSensor3",
            LEFT_SENSOR = "LeftSensor",
            DISPLAY_STATUS_ICONS = "DisplayStatusIcons",
            DISPLAY_SECONDS = "DisplaySeconds"
        }
    }

    module DisplaySecondsType {
        enum Enum {
            NEVER = 0,
            ON_GESTURE = 1,
        }
    }

    function setValue(settingKey as SettingType.Enum, value as String or Boolean or Number) as Void {
        Properties.setValue(settingKey as String, value);
    }

    function getValue(settingKey as SettingType.Enum) as String or Number or Boolean {
        return Properties.getValue(settingKey as String) as String or Number or Boolean;
    }
}
