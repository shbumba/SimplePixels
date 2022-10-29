import Toybox.Lang;
import Toybox.WatchUi;
import SettingsModule.SettingType;
import WatchSettingsMenuBuilder;
import WatchSettingsMenuBuilder.MenuBuilders;
import WatchSettingsMenuBuilder.ItemBuilders;

module WatchSettingsMenu {
    function createMenu() {
        var structure as GenerateMenuProps = {
            :buider => MenuBuilders.MENU,
            :buiderProps => { :title => "Settings" },
            :items => [
                // Color
                {
                    :buider => ItemBuilders.ITEM,
                    :buiderProps => {
                        :identifier => SettingType.BACKGROUND_COLOR,
                        :label => WatchUi.loadResource(Rez.Strings.BackgroundColorTitle),
                        :subLabel => null
                    }
                },
                {
                    :buider => ItemBuilders.ITEM,
                    :buiderProps => {
                        :identifier => SettingType.FOREGROUND_COLOR,
                        :label => WatchUi.loadResource(Rez.Strings.ForegroundColorTitle),
                        :subLabel => "Time color"
                    }
                },
                {
                    :buider => ItemBuilders.ITEM,
                    :buiderProps => {
                        :identifier => SettingType.TEXT_COLOR,
                        :label => WatchUi.loadResource(Rez.Strings.TextColorTitle),
                        :subLabel => "Data color"
                    }
                },
                // Main
                {
                    :buider => ItemBuilders.ITEM,
                    :buiderProps => {
                        :identifier => SettingType.DISPLAY_SECONDS,
                        :label => WatchUi.loadResource(Rez.Strings.DisplaySeconds),
                        :subLabel => null
                    }
                },
                // Separator
                {
                    :buider => ItemBuilders.ITEM,
                    :buiderProps => {
                        :identifier => SettingType.SEPARATOR_COLOR,
                        :label => WatchUi.loadResource(Rez.Strings.SeparatorColorTitle),
                        :subLabel => null
                    }
                },
                {
                    :buider => ItemBuilders.ITEM,
                    :buiderProps => {
                        :identifier => SettingType.SEPARATOR_INFO,
                        :label => WatchUi.loadResource(Rez.Strings.SeparatorInfoTitle),
                        :subLabel => null
                    }
                },
                // Left Sensor Info
                {
                    :buider => ItemBuilders.ITEM,
                    :buiderProps => {
                        :identifier => SettingType.LEFT_SENSOR,
                        :label => WatchUi.loadResource(Rez.Strings.LeftSensor),
                        :subLabel => null
                    }
                },
                {
                    :buider => ItemBuilders.TOGGLE_ITEM,
                    :valueKey => SettingType.DISPLAY_STATUS_ICONS,
                    :buiderProps => {
                        :identifier => SettingType.DISPLAY_STATUS_ICONS,
                        :label => WatchUi.loadResource(Rez.Strings.DisplayStatusIcons),
                        :subLabel => null,
                        :options => {
                            :alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT,
                        }
                    }
                },
                // Top Sensor Fields
                {
                    :buider => ItemBuilders.ITEM,
                    :buiderProps => {
                        :identifier => SettingType.TOP_SENSOR_1,
                        :label => WatchUi.loadResource(Rez.Strings.TopSensor1),
                        :subLabel => null
                    }
                },
                {
                    :buider => ItemBuilders.ITEM,
                    :buiderProps => {
                        :identifier => SettingType.TOP_SENSOR_2,
                        :label => WatchUi.loadResource(Rez.Strings.TopSensor2),
                        :subLabel => null
                    }
                },
                {
                    :buider => ItemBuilders.ITEM,
                    :buiderProps => {
                        :identifier => SettingType.TOP_SENSOR_3,
                        :label => WatchUi.loadResource(Rez.Strings.TopSensor3),
                        :subLabel => null
                    }
                },
                // Bottom Sensor Fields
                {
                    :buider => ItemBuilders.ITEM,
                    :buiderProps => {
                        :identifier => SettingType.BOTTOM_SENSOR_1,
                        :label => WatchUi.loadResource(Rez.Strings.BottomSensor1),
                        :subLabel => null
                    }
                },
                {
                    :buider => ItemBuilders.ITEM,
                    :buiderProps => {
                        :identifier => SettingType.BOTTOM_SENSOR_2,
                        :label => WatchUi.loadResource(Rez.Strings.BottomSensor2),
                        :subLabel => null
                    }
                },
                {
                    :buider => ItemBuilders.ITEM,
                    :buiderProps => {
                        :identifier => SettingType.BOTTOM_SENSOR_3,
                        :label => WatchUi.loadResource(Rez.Strings.BottomSensor3),
                        :subLabel => null
                    }
                }
            ]
        };

        return WatchSettingsMenuBuilder.generateMenu(structure);
    }
}
