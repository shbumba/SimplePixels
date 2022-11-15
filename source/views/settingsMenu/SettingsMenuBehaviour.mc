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
                    :footer => new DrawableMenuFooter()
                }
            },
            :valueKey => settingKey,
            :items => menuItems
        });

        WatchUi.switchToView(
            menu,
            new CustomMenuDelegate(settingKey, clearPrevSensorCache, self.onBackCallback),
            WatchUi.SLIDE_UP
        );
    }

    private function generateColorItems() as Array<GenerateItemProps> {
        var menuItems = [] as Array<GenerateItemProps>;
        var keys = ColorsModule.ColorsDictionary.keys() as Array<ColorsTypes.Enum>;

        for (var i = 0; i < keys.size(); i++) {
            var colorKey = keys[i];

            menuItems.add({
                :buider => SettingsMenuBuilder.CUSTOM_COLOR_ITEM,
                :buiderProps => {
                    :identifier => colorKey as Number,
                    :color => ColorsModule.getColor(colorKey),
                    :label => ColorsModule.getColorName(colorKey)
                }
            });
        }

        return menuItems;
    }

    private function generateSensorItems(settingKey as SensorType.Enum) as Array<GenerateItemProps> {
        var menuItems = [] as Array<GenerateItemProps>;
        var availableKeys = self.subMenuAwailableKeys.get(settingKey);
        var sensorInfoService = Services.SensorInfo();
        var fields = SensorsDisplay.SensorsDictionary.keys() as Array<SensorType.Enum>;

        for (var i = 0; i < fields.size(); i++) {
            var sensorKey = fields[i];

            if (!sensorInfoService.isAwailable(sensorKey)) {
                continue;
            }
            
            var text = SensorsDisplay.getText(sensorKey);

            if (text == null || (availableKeys != null && availableKeys.indexOf(sensorKey) == -1)) {
                continue;
            }
            
            menuItems.add({
                :buider => SettingsMenuBuilder.CUSTOM_ICON_ITEM,
                :buiderProps => {
                    :identifier => sensorKey as Number,
                    :label => text,
                    :icon => SensorsDisplay.getIcon(sensorKey, true)
                }
            });
        }

        return menuItems;
    }

    private function generateSecondsFieldItems() as Array<GenerateItemProps> {
        var menuItems = [] as Array<GenerateItemProps>;
        var secondsFields = {
            DisplaySecondsType.NEVER => Rez.Strings.Never,
            DisplaySecondsType.ON_GESTURE => Rez.Strings.OnGesture
        };
        var keys = secondsFields.keys() as Array<DisplaySecondsType.Enum>;

        for (var i = 0; i < keys.size(); i++) {
            var key = keys[i] as Number;

            menuItems.add({
                :buider => SettingsMenuBuilder.CUSTOM_ICON_ITEM,
                :buiderProps => {
                    :identifier => key,
                    :label => secondsFields.get(key) as Symbol
                }
            });
        }

        return menuItems;
    }

    public function colorHandler(item as WatchUi.MenuItem or WatchUi.CustomMenuItem) as Void {
        self.renderCustomMenu(item.getId(), item.getLabel(), self.generateColorItems(), false);
    }

    public function sensorFieldHandler(item as WatchUi.MenuItem or WatchUi.CustomMenuItem) as Void {
        self.renderCustomMenu(item.getId(), item.getLabel(), self.generateSensorItems(item.getId()), true);
    }

    public function displaySecondsHandler(item as WatchUi.ToggleMenuItem) as Void {
        self.renderCustomMenu(item.getId(), item.getLabel(), self.generateSecondsFieldItems(), false);
    }

    public function toggleFieldHangler(item as WatchUi.ToggleMenuItem) as Void {
        SettingsModule.setValue(item.getId(), item.isEnabled());
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

    function initialize(
        settingKey as SettingType.Enum,
        clearPrevSensorCache as Boolean,
        onBackCallback as Lang.Method
    ) {
        Menu2InputDelegate.initialize();

        self.settingKey = settingKey;
        self.clearPrevSensorCache = clearPrevSensorCache;
        self.onBackCallback = onBackCallback;
    }

    function onSelect(item) {
        if (self.clearPrevSensorCache) {
            var prevValue = SettingsModule.getValue(self.settingKey) as SensorType.Enum;

            ResourcesCache.remove(SensorsDisplay.getIcon(prevValue, true));
        }

        SettingsModule.setValue(self.settingKey, item.getId());
        self.onBack();
    }

    function onBack() {
        RenderSettingsMenu(self.onBackCallback, WatchUi.SLIDE_DOWN, self.settingKey);
    }
}
