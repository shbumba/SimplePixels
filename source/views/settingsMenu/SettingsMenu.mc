import Toybox.Lang;
import Toybox.WatchUi;
import SettingsModule.SettingType;
import SettingsMenuBuilder;
import SensorsTexts;

function RenderSettingsMenu(onBack, transition as WatchUi.SlideType, selectedSetting as SettingType.Enum?) as Void {
    var menu = SettingsMenu();

    if (selectedSetting != null) {
        menu.setFocus(menu.findItemById(selectedSetting as Object));
    }

    WatchUi.switchToView(menu, new SettingsMenuBehaviour(onBack as Method), transition);
}

function _getSubLabelValue(type as SettingType.Enum) as ResourceId {
    return SensorsTexts.getText(SettingsModule.getValue(type) as SensorTypes.Enum);
}

function SettingsMenu() as WatchUi.Menu2 or WatchUi.CustomMenu {
    var menu = SettingsMenuBuilder.generateMenu(SettingsMenuBuilder.MENU, { :title => Rez.Strings.SettingsMenu });
    menu.addItem(
        SettingsMenuBuilder.generateMenuItem(SettingsMenuBuilder.ITEM, {
            :identifier => SettingType.BACKGROUND_COLOR,
            :label => Rez.Strings.BackgroundColorTitle
        })
    );
    menu.addItem(
        SettingsMenuBuilder.generateMenuItem(SettingsMenuBuilder.ITEM, {
            :identifier => SettingType.FOREGROUND_COLOR,
            :label => Rez.Strings.ForegroundColorTitle
        })
    );
    menu.addItem(
        SettingsMenuBuilder.generateMenuItem(SettingsMenuBuilder.ITEM, {
            :identifier => SettingType.INFO_COLOR,
            :label => Rez.Strings.InforColorTitle
        })
    );
    menu.addItem(
        SettingsMenuBuilder.generateMenuItem(SettingsMenuBuilder.ITEM, {
            :identifier => SettingType.DISPLAY_SECONDS,
            :label => Rez.Strings.DisplaySeconds
        })
    );
    menu.addItem(
        SettingsMenuBuilder.generateMenuItem(SettingsMenuBuilder.ITEM, {
            :identifier => SettingType.SEPARATOR_COLOR,
            :label => Rez.Strings.SeparatorColorTitle
        })
    );
    menu.addItem(
        SettingsMenuBuilder.generateMenuItem(SettingsMenuBuilder.ITEM, {
            :identifier => SettingType.SEPARATOR_INFO,
            :label => Rez.Strings.SeparatorInfoTitle,
            :subLabel => _getSubLabelValue(SettingType.SEPARATOR_INFO)
        })
    );
    menu.addItem(
        SettingsMenuBuilder.generateMenuItem(SettingsMenuBuilder.ITEM, {
            :identifier => SettingType.LEFT_SENSOR,
            :label => Rez.Strings.LeftSensor,
            :subLabel => _getSubLabelValue(SettingType.LEFT_SENSOR)
        })
    );
    menu.addItem(
        SettingsMenuBuilder.generateMenuItem(SettingsMenuBuilder.TOGGLE_ITEM, {
            :identifier => SettingType.SHOW_STATUS_ICONS,
            :label => Rez.Strings.DisplayStatusIcons,
            :options => {
                :alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }
        })
    );
    menu.addItem(
        SettingsMenuBuilder.generateMenuItem(SettingsMenuBuilder.ITEM, {
            :identifier => SettingType.TOP_SENSOR_1,
            :label => Rez.Strings.TopSensor1,
            :subLabel => _getSubLabelValue(SettingType.TOP_SENSOR_1)
        })
    );
    menu.addItem(
        SettingsMenuBuilder.generateMenuItem(SettingsMenuBuilder.ITEM, {
            :identifier => SettingType.TOP_SENSOR_2,
            :label => Rez.Strings.TopSensor2,
            :subLabel => _getSubLabelValue(SettingType.TOP_SENSOR_2)
        })
    );
    menu.addItem(
        SettingsMenuBuilder.generateMenuItem(SettingsMenuBuilder.ITEM, {
            :identifier => SettingType.TOP_SENSOR_3,
            :label => Rez.Strings.TopSensor3,
            :subLabel => _getSubLabelValue(SettingType.TOP_SENSOR_3)
        })
    );
    menu.addItem(
        SettingsMenuBuilder.generateMenuItem(SettingsMenuBuilder.ITEM, {
            :identifier => SettingType.BOTTOM_SENSOR_1,
            :label => Rez.Strings.BottomSensor1,
            :subLabel => _getSubLabelValue(SettingType.BOTTOM_SENSOR_1)
        })
    );
    menu.addItem(
        SettingsMenuBuilder.generateMenuItem(SettingsMenuBuilder.ITEM, {
            :identifier => SettingType.BOTTOM_SENSOR_2,
            :label => Rez.Strings.BottomSensor2,
            :subLabel => _getSubLabelValue(SettingType.BOTTOM_SENSOR_2)
        })
    );
    menu.addItem(
        SettingsMenuBuilder.generateMenuItem(SettingsMenuBuilder.ITEM, {
            :identifier => SettingType.BOTTOM_SENSOR_3,
            :label => Rez.Strings.BottomSensor3,
            :subLabel => _getSubLabelValue(SettingType.BOTTOM_SENSOR_3)
        })
    );

    return menu;
}
