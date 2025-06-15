import Toybox.Lang;
import ColorsModule;
import ColorsModule.ColorsTypes;
import SettingsModule.SettingType;
import SettingsModule;

function getSettingColor(
    colorSettingKey as SettingType.FOREGROUND_COLOR or SettingType.BACKGROUND_COLOR or SettingType.INFO_COLOR
) as Number {
    var colorName = SettingsModule.getValue(colorSettingKey) as ColorsTypesEnum;

    return ColorsModule.getColor(colorName);
}
