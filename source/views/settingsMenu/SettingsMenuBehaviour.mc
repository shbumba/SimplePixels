import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import ColorsModule;
import Services;
import SensorsDisplay;
import SensorInfoModule.SensorType;
import SettingsModule;
import SettingsModule.SettingType;
import SettingsModule.DisplaySecondsType;
import SettingsMenuBuilder;

class SettingsMenuBehaviour extends WatchUi.Menu2InputDelegate {
    private var onBackCallback as Lang.Method;
    private var subMenuHandlers = {
        SettingType.BACKGROUND_COLOR => :colorHandler,
        SettingType.FOREGROUND_COLOR => :colorHandler,
        SettingType.INFO_COLOR => :colorHandler,
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

    private var subMenuAwailableKeys = {
        SettingType.SEPARATOR_INFO => [
            SensorType.BATTERY,
            SensorType.ACTIVE_MINUTES_WEEK,
            SensorType.FLOORS,
            SensorType.STEPS
        ],
    };

    private var subMenuUnawailableKeys = {
        SettingType.LEFT_SENSOR => [
            SensorType.IS_DO_NOT_DISTURB,
            SensorType.IS_NIGHT_MODE_ENABLED,
            SensorType.IS_SLEEP_TIME,
            SensorType.IS_CONNECTED,
        ],
    };

    private var secondsFields = {
        DisplaySecondsType.NEVER => Rez.Strings.Never,
        DisplaySecondsType.ON_GESTURE => Rez.Strings.OnGesture,
    };

    function initialize(onBack as Lang.Method) {
        Menu2InputDelegate.initialize();
        self.onBackCallback = onBack;
    }

    private function renderCustomMenu(
        settingKey as SettingType.Enum,
        title as String,
        menuItems as Array<GenerateItemProps>,
        clearPrevSensorCache as Boolean
    ) as Void {
        var menu = SettingsMenuBuilder.generateMenu({
            :buider => SettingsMenuBuilder.CUSTOM_MENU,
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
        });

        WatchUi.switchToView(menu, new CustomMenuDelegate(settingKey, clearPrevSensorCache, self.onBackCallback), WatchUi.SLIDE_UP);
    }

    private function generateColorItems() as Array<GenerateItemProps> {
        var menuItems = [] as Array<GenerateItemProps>;
        var keys = ColorsModule.ColorsDictionary.keys() as Array<ColorsTypes.Enum>;

        for (var i = 0; i < keys.size(); i++) {
            var colorKey = keys[i];
            var color = ColorsModule.getColor(colorKey);
            var colorName = ColorsModule.getColorName(colorKey);

            menuItems.add({
                :buider => SettingsMenuBuilder.CUSTOM_COLOR_ITEM,
                :buiderProps => {
                    :identifier => colorKey as Number,
                    :color => color,
                    :label => colorName
                }
            });
        }

        return menuItems;
    }

    private function generateSensorFieldItems(settingKey as SettingType.Enum) as Array<GenerateItemProps> {
        var menuItems = [] as Array<GenerateItemProps>;
        var keys = SensorsDisplay.SensorsDictionary.keys() as Array<SensorType.Enum>;
        var availableKeys = self.subMenuAwailableKeys.get(settingKey);
        var unavailableKeys = self.subMenuUnawailableKeys.get(settingKey);
        var sensorInfoService = Services.SensorInfo();

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
                :buider => SettingsMenuBuilder.CUSTOM_ICON_ITEM,
                :buiderProps => {
                    :identifier => sensorKey as Number,
                    :label => SensorsDisplay.getText(sensorKey),
                    :icon => SensorsDisplay.getIcon(sensorKey, true)
                }
            });
        }

        return menuItems;
    }

    private function generateSecondsFieldItems() as Array<GenerateItemProps> {
        var menuItems = [] as Array<GenerateItemProps>;
        var keys = self.secondsFields.keys() as Array<ColorsTypes.Enum>;

        for (var i = 0; i < keys.size(); i++) {
            var fieldKey = keys[i];

            menuItems.add({
                :buider => SettingsMenuBuilder.CUSTOM_ICON_ITEM,
                :buiderProps => {
                    :identifier => fieldKey as Number,
                    :label => self.secondsFields.get(fieldKey) as Symbol
                }
            });
        }

        return menuItems;
    }

    public function colorHandler(item as WatchUi.MenuItem or WatchUi.CustomMenuItem) as Void {
        self.renderCustomMenu(item.getId(), item.getLabel(), self.generateColorItems(), false);
    }

    public function sensorFieldHandler(item as WatchUi.MenuItem or WatchUi.CustomMenuItem) as Void {
        self.renderCustomMenu(item.getId(), item.getLabel(), self.generateSensorFieldItems(item.getId()), true);
    }

    public function displaySecondsHandler(item as WatchUi.ToggleMenuItem) as Void {
        self.renderCustomMenu(item.getId(), item.getLabel(), self.generateSecondsFieldItems(), false);
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
    private var settingKey as SettingType.Enum;
    private var onBackCallback as Method;
    private var clearPrevSensorCache as Boolean;

    function initialize(settingKey as SettingType.Enum, clearPrevSensorCache as Boolean, onBackCallback as Lang.Method) {
        Menu2InputDelegate.initialize();

        self.settingKey = settingKey;
        self.clearPrevSensorCache = clearPrevSensorCache;
        self.onBackCallback = onBackCallback;
    }

    function onSelect(item) {
        var valueID = item.getId();

        if (self.clearPrevSensorCache) {
            var prevValue = SettingsModule.getValue(self.settingKey) as SensorType.Enum;
            var icon = SensorsDisplay.getIcon(prevValue, true);

            ResourcesCache.remove(icon);
        }

        SettingsModule.setValue(self.settingKey, valueID);
        self.onBack();
    }

    function onBack() {
        RenderSettingsMenu(self.onBackCallback, WatchUi.SLIDE_DOWN, self.settingKey);
    }
}
