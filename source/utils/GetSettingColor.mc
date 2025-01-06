import Toybox.Lang;
import ColorsModule;
import SettingsModule;
import SettingsModule.SettingType;

function getSettingColor(
    colorSettingKey as SettingType.FOREGROUND_COLOR or SettingType.BACKGROUND_COLOR or SettingType.INFO_COLOR
) as Number {
    var colorName = SettingsModule.getValue(colorSettingKey) as ColorsTypes.Enum;

    return ColorsModule.getColor(colorName);
}
