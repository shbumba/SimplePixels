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
        SettingType.DISPLAY_SECONDS => :displaySecondsHandler,
        SettingType.SECOND_TIME_FORMAT => :displaySecondTimeHandler
    };

    private var subMenuAwailableKeys = {
        SettingType.SEPARATOR_INFO => [
            SensorTypes.BATTERY,
            SensorTypes.ACTIVE_MINUTES_WEEK,
            SensorTypes.FLOORS,
            SensorTypes.STEPS
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
        }, menuItems);

        WatchUi.switchToView(
            menu,
            new CustomMenuDelegate(settingKey, clearPrevSensorCache, self.onBackCallback),
            WatchUi.SLIDE_UP
        );
    }

    private function generateColorItems() as Array<GenerateItemProps> {
        var menuItems = [] as Array<GenerateItemProps>;
        var keys = ColorsModule.ColorsMap.keys() as Array<ColorsTypes.Enum>;

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

    private function generateSensorItems(settingKey as SensorTypes.Enum) as Array<GenerateItemProps> {
        var menuItems = [] as Array<GenerateItemProps>;
        var availableKeys = self.subMenuAwailableKeys.get(settingKey);
        var sensorInfoService = Services.SensorInfo();
        var fields = SensorsTexts.Map.keys() as Array<SensorTypes.Enum>;

        for (var i = 0; i < fields.size(); i++) {
            var sensorKey = fields[i];

            if (!sensorInfoService.isAwailable(sensorKey)) {
                continue;
            }
            
            var text = SensorsTexts.getText(sensorKey);

            if (text == null || (availableKeys != null && availableKeys.indexOf(sensorKey) == -1)) {
                continue;
            }
            
            menuItems.add({
                :buider => SettingsMenuBuilder.CUSTOM_ICON_ITEM,
                :buiderProps => {
                    :identifier => sensorKey as Number,
                    :label => text,
                    :icon => SensorsIcons.getIcon(sensorKey, true)
                }
            });
        }

        return menuItems;
    }

    private function generateMapItems(mapFields as Dictionary) as Array<GenerateItemProps> {
        var menuItems = [] as Array<GenerateItemProps>;
        var keys = mapFields.keys() as Array<Number>;

        for (var i = 0; i < keys.size(); i++) {
            var key = keys[i] as Number;

            menuItems.add({
                :buider => SettingsMenuBuilder.CUSTOM_ICON_ITEM,
                :buiderProps => {
                    :identifier => key,
                    :label => mapFields.get(key) as Symbol
                }
            });
        }

        return menuItems;
    }

    private function generateTimeZones() as Array<GenerateItemProps> {
        var menuItems = [] as Array<GenerateItemProps>;

        for (var i = 0; i < TimeStackModule.TIME_ZONES.size(); i++) {
            var timeZone = TimeStackModule.TIME_ZONES[i];
            var positiveTimeZone = timeZone > 0 ? timeZone : (timeZone / -1);
            var formatedTimeZone = Time.Gregorian.utcInfo(new Time.Moment(positiveTimeZone * 60 * 60), Time.FORMAT_SHORT);
            var timeSymbol = timeZone > 0 ? "+" : timeZone < 0 ? "-" : "";
            var formatedTime = Lang.format("$1$$2$:$3$", [timeSymbol, formatedTimeZone.hour.format("%02u"), formatedTimeZone.min.format("%02u")]);

            menuItems.add({
                :buider => SettingsMenuBuilder.CUSTOM_ICON_ITEM,
                :buiderProps => {
                    :identifier => timeZone,
                    :label => formatedTime
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
        self.renderCustomMenu(item.getId(), item.getLabel(), self.generateMapItems({
            DisplaySecondsType.NEVER => Rez.Strings.Never,
            DisplaySecondsType.ON_GESTURE => Rez.Strings.OnGesture
        }), false);
    }

    public function toggleFieldHangler(item as WatchUi.ToggleMenuItem) as Void {
        SettingsModule.setValue(item.getId(), item.isEnabled());
    }

    public function displaySecondTimeHandler(item as WatchUi.MenuItem or WatchUi.CustomMenuItem) as Void {
        self.renderCustomMenu(item.getId(), item.getLabel(), self.generateTimeZones(), false);
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

    function onSelect(item) as Void {
        if (self.clearPrevSensorCache) {
            var prevValue = SettingsModule.getValue(self.settingKey) as SensorTypes.Enum;

            ResourcesCache.remove(SensorsIcons.getIcon(prevValue, true));
        }

        SettingsModule.setValue(self.settingKey, item.getId());
        self.onBack();
    }

    function onBack() as Void {
        RenderSettingsMenu(self.onBackCallback, WatchUi.SLIDE_DOWN, self.settingKey);
    }
}
