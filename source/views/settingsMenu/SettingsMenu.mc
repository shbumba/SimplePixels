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

function _getSubLabelValue(type as SettingType.Enum) as Symbol {
    return SensorsTexts.getText(SettingsModule.getValue(type) as SensorTypes.Enum);
}

function SettingsMenu() as WatchUi.Menu2 or WatchUi.CustomMenu {
    return SettingsMenuBuilder.generateMenu(
        {
            :buider => SettingsMenuBuilder.MENU,
            :buiderProps => { :title => Rez.Strings.SettingsMenu }
        },
        [
            // Color
            {
                :buider => SettingsMenuBuilder.ITEM,
                :buiderProps => {
                    :identifier => SettingType.BACKGROUND_COLOR,
                    :label => Rez.Strings.BackgroundColorTitle
                }
            },
            {
                :buider => SettingsMenuBuilder.ITEM,
                :buiderProps => {
                    :identifier => SettingType.FOREGROUND_COLOR,
                    :label => Rez.Strings.ForegroundColorTitle
                }
            },
            {
                :buider => SettingsMenuBuilder.ITEM,
                :buiderProps => {
                    :identifier => SettingType.INFO_COLOR,
                    :label => Rez.Strings.InforColorTitle
                }
            },
            // Main
            {
                :buider => SettingsMenuBuilder.ITEM,
                :buiderProps => {
                    :identifier => SettingType.DISPLAY_SECONDS,
                    :label => Rez.Strings.DisplaySeconds
                }
            },
            // Separator
            {
                :buider => SettingsMenuBuilder.ITEM,
                :buiderProps => {
                    :identifier => SettingType.SEPARATOR_COLOR,
                    :label => Rez.Strings.SeparatorColorTitle
                }
            },
            {
                :buider => SettingsMenuBuilder.ITEM,
                :buiderProps => {
                    :identifier => SettingType.SEPARATOR_INFO,
                    :label => Rez.Strings.SeparatorInfoTitle,
                    :subLabel => _getSubLabelValue(SettingType.SEPARATOR_INFO)
                }
            },
            // Second Time Format
            {
                :buider => SettingsMenuBuilder.ITEM,
                :buiderProps => {
                    :identifier => SettingType.SECOND_TIME_FORMAT,
                    :label => Rez.Strings.SecondTimeFormat
                }
            },
            // Left Sensor Info
            {
                :buider => SettingsMenuBuilder.ITEM,
                :buiderProps => {
                    :identifier => SettingType.LEFT_SENSOR,
                    :label => Rez.Strings.LeftSensor,
                    :subLabel => _getSubLabelValue(SettingType.LEFT_SENSOR)
                }
            },
            {
                :buider => SettingsMenuBuilder.TOGGLE_ITEM,
                :valueKey => SettingType.DISPLAY_STATUS_ICONS,
                :buiderProps => {
                    :identifier => SettingType.DISPLAY_STATUS_ICONS,
                    :label => Rez.Strings.DisplayStatusIcons,
                    :options => {
                        :alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
                    }
                }
            },
            // Top Sensor Fields
            {
                :buider => SettingsMenuBuilder.ITEM,
                :buiderProps => {
                    :identifier => SettingType.TOP_SENSOR_1,
                    :label => Rez.Strings.TopSensor1,
                    :subLabel => _getSubLabelValue(SettingType.TOP_SENSOR_1)
                }
            },
            {
                :buider => SettingsMenuBuilder.ITEM,
                :buiderProps => {
                    :identifier => SettingType.TOP_SENSOR_2,
                    :label => Rez.Strings.TopSensor2,
                    :subLabel => _getSubLabelValue(SettingType.TOP_SENSOR_2)
                }
            },
            {
                :buider => SettingsMenuBuilder.ITEM,
                :buiderProps => {
                    :identifier => SettingType.TOP_SENSOR_3,
                    :label => Rez.Strings.TopSensor3,
                    :subLabel => _getSubLabelValue(SettingType.TOP_SENSOR_3)
                }
            },
            // Bottom Sensor Fields
            {
                :buider => SettingsMenuBuilder.ITEM,
                :buiderProps => {
                    :identifier => SettingType.BOTTOM_SENSOR_1,
                    :label => Rez.Strings.BottomSensor1,
                    :subLabel => _getSubLabelValue(SettingType.BOTTOM_SENSOR_1)
                }
            },
            {
                :buider => SettingsMenuBuilder.ITEM,
                :buiderProps => {
                    :identifier => SettingType.BOTTOM_SENSOR_2,
                    :label => Rez.Strings.BottomSensor2,
                    :subLabel => _getSubLabelValue(SettingType.BOTTOM_SENSOR_2)
                }
            },
            {
                :buider => SettingsMenuBuilder.ITEM,
                :buiderProps => {
                    :identifier => SettingType.BOTTOM_SENSOR_3,
                    :label => Rez.Strings.BottomSensor3,
                    :subLabel => _getSubLabelValue(SettingType.BOTTOM_SENSOR_3)
                }
            }
        ] as Array<GenerateItemProps>
    );
}
