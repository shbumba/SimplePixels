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

class SettingsMenuBehavior extends WatchUi.Menu2InputDelegate {
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
        SettingType.SHOW_STATUS_ICONS => :toggleFieldHandler,
        SettingType.DISPLAY_SECONDS => :displaySecondsHandler
    };

    function initialize(onBack as Lang.Method) {
        Menu2InputDelegate.initialize();
        Services.SensorInfo().init();
        ResourcesCache.clear();
        self._onBackCallback = onBack;
    }

    function _createCustomMenu(title as String) as WatchUi.Menu2 or WatchUi.CustomMenu {
        return new WatchUi.CustomMenu(35, Graphics.COLOR_WHITE, {
                :focusItemHeight => 45,
                :title => new DrawableMenuTitle(title),
                :footer => new DrawableMenuFooter()
            });
    }

    function _addColorItems(menu as WatchUi.CustomMenu or WatchUi.Menu2) as Void {
        var keys = ColorsModule.ColorsMap.keys() as Array<ColorsTypes.Enum>;

        for (var i = 0; i < keys.size(); i++) {
            var colorKey = keys[i];

            menu.addItem(
                SettingsMenuBuilder.BuildCustomColorMenuItem({
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

            if (text == null || !sensorInfoService.isAvailable(sensorKey)) {
                continue;
            }

            menu.addItem(
                SettingsMenuBuilder.BuildCustomIconMenuItem({
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
                SettingsMenuBuilder.BuildCustomIconMenuItem({
                    :identifier => key,
                    :label => mapFields.get(key) as ResourceId
                })
            );
        }
    }

    function colorHandler(item as WatchUi.MenuItem or WatchUi.CustomMenuItem) as Void {
        var menu = self._createCustomMenu(item.getLabel());

        self.openMenu(item.getId() as SettingType.Enum, menu);
        self._addColorItems(menu);
        self.setFocusOnItem(item.getId() as SettingType.Enum, menu);
    }

    function sensorFieldHandler(item as WatchUi.MenuItem or WatchUi.CustomMenuItem) as Void {
        var menu = self._createCustomMenu(item.getLabel());

        self.openMenu(item.getId() as SettingType.Enum, menu);
        self._addSensorItems(menu, null);
        self.setFocusOnItem(item.getId() as SettingType.Enum, menu);
    }

    function separatorFieldHandler(item as WatchUi.MenuItem or WatchUi.CustomMenuItem) as Void {
        var menu = self._createCustomMenu(item.getLabel());
        
        self.openMenu(item.getId() as SettingType.Enum, menu);
        self._addSensorItems(menu, [
            SensorTypes.BATTERY,
            SensorTypes.ACTIVE_MINUTES_WEEK,
            SensorTypes.FLOORS,
            SensorTypes.STEPS
        ]);
        self.setFocusOnItem(item.getId() as SettingType.Enum, menu);
    }

    function displaySecondsHandler(item as WatchUi.ToggleMenuItem) as Void {
        var menu = self._createCustomMenu(item.getLabel());
        
        self.openMenu(item.getId() as SettingType.Enum, menu);
        self._addMapItems(menu, {
            DisplaySecondsType.NEVER => Rez.Strings.Never,
            DisplaySecondsType.ON_GESTURE => Rez.Strings.OnGesture
        });
        self.setFocusOnItem(item.getId() as SettingType.Enum, menu);
    }

    function toggleFieldHandler(item as WatchUi.ToggleMenuItem) as Void {
        SettingsModule.setValue(item.getId() as SettingType.Enum, item.isEnabled());
    }

    function setFocusOnItem(
        settingKey as SettingType.Enum,
        menu as WatchUi.Menu2 or WatchUi.CustomMenu
    ) as Void {
        SettingsMenuBuilder.setFocusOnMenuItem(menu, settingKey);
    }

    function openMenu(
        settingKey as SettingType.Enum,
        menu as WatchUi.Menu2 or WatchUi.CustomMenu
    ) as Void {
        WatchUi.switchToView(
            menu,
            new CustomMenuDelegate(settingKey, self._onBackCallback),
            WatchUi.SLIDE_IMMEDIATE
        );
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        ResourcesCache.clear();

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

    function initialize(
        settingKey as SettingType.Enum,
        onBackCallback as Lang.Method
    ) {
        Menu2InputDelegate.initialize();
        ResourcesCache.clear();

        self._settingKey = settingKey;
        self._onBackCallback = onBackCallback;
    }

    function onSelect(item) as Void {
        SettingsModule.setValue(self._settingKey, item.getId() as SettingType.Enum);
        self.onBack();
    }

    function onBack() as Void {
        RenderSettingsMenu(self._onBackCallback, WatchUi.SLIDE_DOWN, self._settingKey);
    }
}
