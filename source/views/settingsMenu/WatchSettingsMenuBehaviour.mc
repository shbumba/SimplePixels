import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import ColorsModule;
import Services;
import Services.ServiceType;
import SensorInfoModule.SensorsDisplay;
import SensorInfoModule.SensorType;
import SettingsModule;
import SettingsModule.SettingType;
import SettingsModule.DisplaySecondsType;
import WatchSettingsMenuBuilder;
import WatchSettingsMenuBuilder.MenuBuilders;
import WatchSettingsMenuBuilder.ItemBuilders;

class WatchSettingsMenuBehaviour extends WatchUi.Menu2InputDelegate {
    private var onBackCallback as Lang.Method;
    private var subMenuHandlers as Dictionary = {
        SettingType.BACKGROUND_COLOR => :colorHandler,
        SettingType.FOREGROUND_COLOR => :colorHandler,
        SettingType.TEXT_COLOR => :colorHandler,
        SettingType.SEPARATOR_COLOR => :colorHandler,
        SettingType.SEPARATOR_INFO => :sensorFieldHandler,
        SettingType.TOP_SENSOR_1 => :sensorFieldHandler,
        SettingType.TOP_SENSOR_2 => :sensorFieldHandler,
        SettingType.TOP_SENSOR_3 => :sensorFieldHandler,
        SettingType.BOTTOM_SENSOR_1 => :sensorFieldHandler,
        SettingType.BOTTOM_SENSOR_2 => :sensorFieldHandler,
        SettingType.BOTTOM_SENSOR_3 => :sensorFieldHandler,
        SettingType.LEFT_SENSOR => :sensorFieldHandler,
        SettingType.DISPLAY_STATUS_ICONS => :toggleFieldHangler,
        SettingType.DISPLAY_SECONDS => :displaySecondsHandler
    };

    private var subMenuAwailableKeys as Dictionary = {
        SettingType.SEPARATOR_INFO => [
            SensorType.BATTERY,
            SensorType.ACTIVE_MINUTES_WEEK,
            SensorType.FLOORS,
            SensorType.STEPS
        ],
    };

    private var subMenuUnawailableKeys as Dictionary = {
        SettingType.LEFT_SENSOR => [
            SensorType.IS_CHARGING,
            SensorType.IS_DO_NOT_DISTURB,
            SensorType.IS_NIGHT_MODE_ENABLED,
            SensorType.IS_SLEEP_TIME,
            SensorType.IS_CONNECTED,
        ],
    };

    private var secondsFields as Dictionary = {
        DisplaySecondsType.NEVER => Rez.Strings.Never,
        DisplaySecondsType.ON_GESTURE => Rez.Strings.OnGesture,
    };

    function initialize(onBack as Lang.Method) {
        Menu2InputDelegate.initialize();
        self.onBackCallback = onBack;
    }

    private function renderCustomMenu(
        settingKey as SettingType,
        title as String,
        menuItems as Array<GenerateItemProps>,
        clearPrevSensorCache as Boolean?
    ) as Void {
        var structure as GenerateMenuProps = {
            :buider => MenuBuilders.CUSTOM_MENU,
            :buiderProps => {
                :itemHeight => 35,
                :backgroundColor => Graphics.COLOR_WHITE,
                :options => {
                    :focusItemHeight => 45,
                    :title => new DrawableMenuTitle(title),
                    :foreground => new Rez.Drawables.MenuForeground(),
                    :footer => new DrawableMenuFooter()
                }
            },
            :valueKey => settingKey,
            :items => menuItems
        };

        var menu = WatchSettingsMenuBuilder.generateMenu(structure);

        WatchUi.pushView(menu, new CustomMenuDelegate(settingKey, clearPrevSensorCache), WatchUi.SLIDE_UP);
    }

    private function generateColorItems() as Array<GenerateItemProps> {
        var menuItems = [];
        var keys = ColorsModule.ColorsDictionary.keys();

        for (var i = 0; i < keys.size(); i++) {
            var colorKey = keys[i];
            var color = ColorsModule.getColor(colorKey);
            var colorName = ColorsModule.getColorName(colorKey);

            menuItems.add({
                :buider => ItemBuilders.CUSTOM_COLOR_ITEM,
                :buiderProps => {
                    :identifier => colorKey,
                    :color => color,
                    :label => colorName
                }
            });
        }

        return menuItems;
    }

    private function generateSensorFieldItems(settingKey as SettingType) as Array<GenerateItemProps> {
        var menuItems = [];
        var keys = SensorsDisplay.SensorsDictionary.keys();
        var availableKeys = self.subMenuAwailableKeys.get(settingKey);
        var unavailableKeys = self.subMenuUnawailableKeys.get(settingKey);
        var sensorInfoService = Services.get(ServiceType.SENSORS_INFO);

        for (var i = 0; i < keys.size(); i++) {
            var sensorKey = keys[i];

            if (!sensorInfoService.isAwailable(sensorKey)) {
                continue;
            } else if (availableKeys != null && availableKeys.indexOf(sensorKey) == -1) {
                continue;
            } else if (unavailableKeys != null && unavailableKeys.indexOf(sensorKey) > -1) {
                continue;
            }
            
            menuItems.add({
                :buider => ItemBuilders.CUSTOM_ICON_ITEM,
                :buiderProps => {
                    :identifier => sensorKey,
                    :label => SensorsDisplay.getText(sensorKey),
                    :icon => SensorsDisplay.getIcon(sensorKey, true)
                }
            });
        }

        return menuItems;
    }

    private function generateSecondsFieldItems() as Array<GenerateItemProps> {
        var menuItems = [];
        var keys = self.secondsFields.keys();

        for (var i = 0; i < keys.size(); i++) {
            var fieldKey = keys[i];

            menuItems.add({
                :buider => ItemBuilders.CUSTOM_ICON_ITEM,
                :buiderProps => {
                    :identifier => fieldKey,
                    :label => self.secondsFields.get(fieldKey)
                }
            });
        }

        return menuItems;
    }

    public function colorHandler(item as WatchUi.MenuItem or WatchUi.CustomMenuItem) as Void {
        self.renderCustomMenu(item.getId(), item.getLabel(), self.generateColorItems());
    }

    public function sensorFieldHandler(item as WatchUi.MenuItem or WatchUi.CustomMenuItem) as Void {
        self.renderCustomMenu(item.getId(), item.getLabel(), self.generateSensorFieldItems(item.getId()), true);
    }

    public function displaySecondsHandler(item as WatchUi.ToggleMenuItem) as Void {
        self.renderCustomMenu(item.getId(), item.getLabel(), self.generateSecondsFieldItems());
    }

    public function toggleFieldHangler(item as WatchUi.ToggleMenuItem) as Void {
        var value = item.isEnabled();

        SettingsModule.setValue(item.getId(), value);
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var handler = self.subMenuHandlers.get(item.getId());

        if (handler == null) {
            throw new Toybox.Lang.InvalidValueException("Handler is not registered");
        }

        var method = new Lang.Method(self, handler);

        method.invoke(item);
    }

    function onBack() as Void {
        self.onBackCallback.invoke();

        WatchUi.Menu2InputDelegate.onBack();
    }
}

class CustomMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var settingKey as String;
    private var clearPrevSensorCache as Boolean = false;

    function initialize(settingKey, clearPrevSensorCache as Boolean?) {
        Menu2InputDelegate.initialize();

        self.settingKey = settingKey;

        if (clearPrevSensorCache != null) {
            self.clearPrevSensorCache = clearPrevSensorCache;
        }
    }

    function onSelect(item) {
        var valueID = item.getId();

        if (self.clearPrevSensorCache) {
            var prevValue = SettingsModule.getValue(self.settingKey);
            var icon = SensorsDisplay.getIcon(prevValue, true);

            ResourcesCache.remove(icon);
        }

        SettingsModule.setValue(self.settingKey, valueID);

        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function onWrap(key) {
        return false;
    }
}
