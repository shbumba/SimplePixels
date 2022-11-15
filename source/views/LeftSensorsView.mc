import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Services;
import SensorInfoModule.SensorType;
import SettingsModule;
import SettingsModule.SettingType;

class LeftSensorsView extends Component.List {
    private var _sensorType as SensorType.Enum = SensorType.NONE;
    private var _displayIcons as Boolean = false;
    private var sleepSensors as Array<SensorType.Enum> =
        [SensorType.IS_NIGHT_MODE_ENABLED, SensorType.IS_SLEEP_TIME] as Array<SensorType.Enum>;
    private var iconSensors as Array<SensorType.Enum> =
        [
            SensorType.IS_CONNECTED,
            SensorType.IS_DO_NOT_DISTURB,
            SensorType.IS_SLEEP_TIME,
            SensorType.IS_NIGHT_MODE_ENABLED
        ] as Array<SensorType.Enum>;

    function initialize(params as Component.ListProps) {
        List.initialize(params);
        self.updateSensorType();
        self.updateDisplayIcons();
    }

    private function updateSensorType() as Void {
        self._sensorType = SettingsModule.getValue(SettingType.LEFT_SENSOR) as SensorType.Enum;
    }

    private function updateDisplayIcons() as Void {
        self._displayIcons = SettingsModule.getValue(SettingType.DISPLAY_STATUS_ICONS) as Boolean;
    }

    function onSettingsChanged() {
        Component.List.onSettingsChanged();

        self.updateSensorType();
        self.updateDisplayIcons();
    }

    private function getSensorItem(sensorType as SensorType.Enum) as Component.ItemType {
        var sensorService = Services.SensorInfo();

        var icon = sensorService.getIcon(sensorType);

        if (sensorType == SensorType.BATTERY_IN_DAYS) {
            icon = sensorService.getIcon(SensorType.BATTERY);
        }

        return {
            :text => sensorService.transformValue(sensorType),
            :icon => icon
        };
    }

    private function getIconsItem() as Component.ItemType {
        var sensorService = Services.SensorInfo();
        var icons = [] as Array<FontResource>;
        var hasSleepMode = false;

        for (var i = 0; i < self.iconSensors.size(); i++) {
            var iconSensorType = self.iconSensors[i];
            var iconSensorValue = sensorService.getValue(iconSensorType);

            if (iconSensorValue == false || iconSensorValue == null) {
                continue;
            }

            var isSleepSensor = self.sleepSensors.indexOf(iconSensorType) > -1;

            if (isSleepSensor && hasSleepMode) {
                continue;
            } else if (isSleepSensor && !hasSleepMode) {
                hasSleepMode = true;
            }

            icons.add(sensorService.getIcon(iconSensorType));
        }

        return {
            :icons => icons
        };
    }

    protected function render(drawContext as Dc) as Void {
        var items = [] as Array<Component.ItemType>;

        if (self._sensorType != SensorType.NONE) {
            items.add(self.getSensorItem(self._sensorType));
        }

        if (self._displayIcons == true) {
            items.add(self.getIconsItem());
        }

        drawContext.setColor(self.infoColor, Graphics.COLOR_TRANSPARENT);

        self.renderItems({
            :items => items,
            :direction => Component.ListItemsDerection.RIGHT,
            :drawContext => drawContext
        });
    }
}
