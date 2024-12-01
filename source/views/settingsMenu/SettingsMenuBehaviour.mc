import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Time;
import ColorsModule;
import Services;
import SettingsModule;
import SettingsModule.SettingType;
import SettingsModule.DisplaySecondsType;
import SettingsMenuBuilder;
import SensorTypes;
import SensorsTexts;
import SensorsIcons;
import ResourcesCache;
import TimeStackModule;

class SettingsMenuBehaviour extends WatchUi.Menu2InputDelegate {
    var _onBackCallback as Lang.Method;
    var _subMenuHandlers = {
        SettingType.BACKGROUND_COLOR => :colorHandler,
        SettingType.FOREGROUND_COLOR => :colorHandler,
        SettingType.INFO_COLOR => :colorHandler,
        SettingType.SEPARATOR_COLOR => :colorHandler,
        SettingType.SEPARATOR_INFO => :separatorFieldHandler,
        SettingType.TOP_SENSOR_1 => :sensorFieldHandler,
        SettingType.TOP_SENSOR_2 => :sensorFieldHandler,
        SettingType.TOP_SENSOR_3 => :sensorFieldHandler,
        SettingType.BOTTOM_SENSOR_1 => :sensorFieldHandler,
        SettingType.BOTTOM_SENSOR_2 => :sensorFieldHandler,
        SettingType.BOTTOM_SENSOR_3 => :sensorFieldHandler,
        SettingType.LEFT_SENSOR => :sensorFieldHandler,
        SettingType.SHOW_STATUS_ICONS => :toggleFieldHangler,
        SettingType.DISPLAY_SECONDS => :displaySecondsHandler,
        SettingType.SECOND_TIME_FORMAT => :displaySecondTimeHandler,
        SettingType.DOT_HOUR_TRANS => :displayPatternTransHandler,
        SettingType.DATE_FORMAT => :displayDateFormatHandler
    };

    function initialize(onBack as Lang.Method) {
        Menu2InputDelegate.initialize();
        Services.SensorInfo().init();
        self._onBackCallback = onBack;
    }

    function _createCustomMenu(title as String) as WatchUi.Menu2 or WatchUi.CustomMenu {
        return SettingsMenuBuilder.generateMenu(SettingsMenuBuilder.CUSTOM_MENU, {
            :itemHeight => 35,
            :backgroundColor => Graphics.COLOR_WHITE,
            :options => {
                :focusItemHeight => 45,
                :title => new DrawableMenuTitle(title),
                :footer => new DrawableMenuFooter()
            }
        });
    }

    function _addColorItems(menu as WatchUi.CustomMenu or WatchUi.Menu2) as Void {
        var keys = ColorsModule.ColorsMap.keys() as Array<ColorsTypes.Enum>;

        for (var i = 0; i < keys.size(); i++) {
            var colorKey = keys[i];

            menu.addItem(
                SettingsMenuBuilder.generateMenuItem(SettingsMenuBuilder.CUSTOM_COLOR_ITEM, {
                    :identifier => colorKey as Number,
                    :color => ColorsModule.getColor(colorKey),
                    :label => ColorsModule.getColorName(colorKey)
                })
            );
        }
    }

    function _addSensorItems(
        menu as WatchUi.CustomMenu or WatchUi.Menu2,
        availableFields as Array<SensorTypes.Enum>?
    ) as Void {
        var sensorInfoService = Services.SensorInfo();
        var fields = availableFields != null ? availableFields : SensorsTexts.Map.keys() as Array<SensorTypes.Enum>;

        for (var i = 0; i < fields.size(); i++) {
            var sensorKey = fields[i];
            var text = SensorsTexts.getText(sensorKey);

            if (text == null || !sensorInfoService.isAwailable(sensorKey)) {
                continue;
            }

            menu.addItem(
                SettingsMenuBuilder.generateMenuItem(SettingsMenuBuilder.CUSTOM_ICON_ITEM, {
                    :identifier => sensorKey as Number,
                    :label => text,
                    :icon => SensorsIcons.getIcon(sensorKey, true)
                })
            );
        }
    }

    function _addMapItems(menu as WatchUi.CustomMenu or WatchUi.Menu2, mapFields as Dictionary) as Void {
        var keys = mapFields.keys() as Array<Number>;

        for (var i = 0; i < keys.size(); i++) {
            var key = keys[i] as Number;

            menu.addItem(
                SettingsMenuBuilder.generateMenuItem(SettingsMenuBuilder.CUSTOM_ICON_ITEM, {
                    :identifier => key,
                    :label => mapFields.get(key) as ResourceId
                })
            );
        }
    }

    function _addTimeZones(menu as WatchUi.CustomMenu or WatchUi.Menu2) as Void {
        for (var i = 0; i < TimeStackModule.TIME_ZONES.size(); i++) {
            var timeZone = TimeStackModule.TIME_ZONES[i] as Numeric;
            var positiveTimeZone = timeZone > 0 ? timeZone : timeZone / -1;
            var formatedTimeZone = Time.Gregorian.utcInfo(
                new Time.Moment(positiveTimeZone * 60 * 60),
                Time.FORMAT_SHORT
            );
            var timeSymbol = timeZone > 0 ? "+" : timeZone < 0 ? "-" : "";
            var formatedTime = Lang.format("$1$$2$:$3$", [
                timeSymbol,
                formatedTimeZone.hour.format("%02u"),
                formatedTimeZone.min.format("%02u")
            ]);

            menu.addItem(
                SettingsMenuBuilder.generateMenuItem(SettingsMenuBuilder.CUSTOM_ICON_ITEM, {
                    :identifier => timeZone,
                    :label => formatedTime
                })
            );
        }
    }

    function colorHandler(item as WatchUi.MenuItem or WatchUi.CustomMenuItem) as Void {
        var menu = self._createCustomMenu(item.getLabel());
        self._addColorItems(menu);

        self.openMenu(item.getId() as SettingType.Enum, menu, false);
    }

    function sensorFieldHandler(item as WatchUi.MenuItem or WatchUi.CustomMenuItem) as Void {
        var menu = self._createCustomMenu(item.getLabel());
        self._addSensorItems(menu, null);

        self.openMenu(item.getId() as SettingType.Enum, menu, true);
    }

    function separatorFieldHandler(item as WatchUi.MenuItem or WatchUi.CustomMenuItem) as Void {
        var menu = self._createCustomMenu(item.getLabel());
        self._addSensorItems(menu, [
            SensorTypes.BATTERY,
            SensorTypes.ACTIVE_MINUTES_WEEK,
            SensorTypes.FLOORS,
            SensorTypes.STEPS
        ]);

        self.openMenu(item.getId() as SettingType.Enum, menu, false);
    }

    function displaySecondsHandler(item as WatchUi.ToggleMenuItem) as Void {
        var menu = self._createCustomMenu(item.getLabel());
        self._addMapItems(menu, {
            DisplaySecondsType.NEVER => Rez.Strings.Never,
            DisplaySecondsType.ON_GESTURE => Rez.Strings.OnGesture
        });

        self.openMenu(item.getId() as SettingType.Enum, menu, false);
    }

    function toggleFieldHangler(item as WatchUi.ToggleMenuItem) as Void {
        SettingsModule.setValue(item.getId() as SettingType.Enum, item.isEnabled());
    }

    function displaySecondTimeHandler(item as WatchUi.MenuItem or WatchUi.CustomMenuItem) as Void {
        var menu = self._createCustomMenu(item.getLabel());
        self._addTimeZones(menu);

        self.openMenu(item.getId() as SettingType.Enum, menu, false);
    }

    function displayPatternTransHandler(item as WatchUi.MenuItem or WatchUi.CustomMenuItem) as Void {
        var menu = self._createCustomMenu(item.getLabel());

        if (GlobalKeys.CAN_CREATE_COLOR) {
            self._addMapItems(menu, {
                0 => "0%",
                25 => "25%",
                50 => "50%",
                75 => "75%",
                100 => "100%"
            });
        } else {
            self._addMapItems(menu, {
                0 => "0%",
                100 => "100%"
            });
        }

        self.openMenu(item.getId() as SettingType.Enum, menu, false);
    }

    function displayDateFormatHandler(item as WatchUi.ToggleMenuItem) as Void {
        var menu = self._createCustomMenu(item.getLabel());
        self._addMapItems(menu, {
            DisplayDateFormatType.DDMM => Rez.Strings.DateFormatEng,
            DisplayDateFormatType.MMDD => Rez.Strings.DateFormatMMdd
        });

        self.openMenu(item.getId() as SettingType.Enum, menu, false);
    }

    function openMenu(
        settingKey as SettingType.Enum,
        menu as WatchUi.Menu2 or WatchUi.CustomMenu,
        clearPrevSensorCache as Boolean
    ) as Void {
        SettingsMenuBuilder.setFocusOnMenuItem(menu, settingKey);

        WatchUi.switchToView(
            menu,
            new CustomMenuDelegate(settingKey, clearPrevSensorCache, self._onBackCallback),
            WatchUi.SLIDE_IMMEDIATE
        );
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var handler = self._subMenuHandlers.get(item.getId() as SettingType.Enum);

        if (handler == null) {
            throw new Toybox.Lang.InvalidValueException("Handler is not registered");
        }

        var method = new Lang.Method(self, handler);

        method.invoke(item);
    }

    function onBack() as Void {
        self._onBackCallback.invoke();
        WatchUi.Menu2InputDelegate.onBack();
    }
}

class CustomMenuDelegate extends WatchUi.Menu2InputDelegate {
    var _settingKey as SettingType.Enum;
    var _onBackCallback as Method;
    var _clearPrevSensorCache as Boolean;

    function initialize(
        settingKey as SettingType.Enum,
        clearPrevSensorCache as Boolean,
        onBackCallback as Lang.Method
    ) {
        Menu2InputDelegate.initialize();

        self._settingKey = settingKey;
        self._clearPrevSensorCache = clearPrevSensorCache;
        self._onBackCallback = onBackCallback;
    }

    function onSelect(item) as Void {
        if (self._clearPrevSensorCache) {
            var prevValue = SettingsModule.getValue(self._settingKey) as SensorTypes.Enum;

            ResourcesCache.remove(SensorsIcons.getIcon(prevValue, true));
        }

        SettingsModule.setValue(self._settingKey, item.getId() as SettingType.Enum);
        self.onBack();
    }

    function onBack() as Void {
        RenderSettingsMenu(self._onBackCallback, WatchUi.SLIDE_DOWN, self._settingKey);
    }
}
