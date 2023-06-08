import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Services;
import SettingsModule;
import SettingsModule.SettingType;
import SensorTypes;
import Components;

class LeftSensorsView extends Components.List {
    private var _sensorType as SensorTypes.Enum = SensorTypes.NONE;
    private var _areIconsVisible as Boolean = false;
    private var sleepSensors as Array<SensorTypes.Enum> =
        [SensorTypes.IS_NIGHT_MODE_ENABLED, SensorTypes.IS_SLEEP_TIME] as Array<SensorTypes.Enum>;
    private var iconSensors as Array<SensorTypes.Enum> =
        [
            SensorTypes.IS_CONNECTED,
            SensorTypes.IS_DO_NOT_DISTURB,
            SensorTypes.IS_SLEEP_TIME,
            SensorTypes.IS_NIGHT_MODE_ENABLED
        ] as Array<SensorTypes.Enum>;

    function initialize(params as Components.ListProps) {
        List.initialize(params);
        self.updateSensorType();
        self.updateDisplayIcons();
    }

    private function updateSensorType() as Void {
        self._sensorType = SettingsModule.getValue(SettingType.LEFT_SENSOR) as SensorTypes.Enum;
    }

    private function updateDisplayIcons() as Void {
        self._areIconsVisible = SettingsModule.getValue(SettingType.SHOW_STATUS_ICONS) as Boolean;
    }

    function onSettingsChanged() as Void {
        Components.List.onSettingsChanged();

        self.updateSensorType();
        self.updateDisplayIcons();
    }

    private function getSensorItem(sensorType as SensorTypes.Enum) as Components.ItemType {
        var sensorService = Services.SensorInfo();

        var icon = sensorService.getIcon(sensorType);

        if (sensorType == SensorTypes.BATTERY_IN_DAYS) {
            icon = sensorService.getIcon(SensorTypes.BATTERY);
        }

        return {
            :text => sensorService.transformValue(sensorType),
            :icon => icon
        };
    }

    private function getIconsItem() as Components.ItemType {
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
        var items = [] as Array<Components.ItemType>;

        if (self._sensorType != SensorTypes.NONE) {
            items.add(self.getSensorItem(self._sensorType));
        }

        if (self._areIconsVisible == true) {
            items.add(self.getIconsItem());
        }

        drawContext.setColor(self.infoColor, Graphics.COLOR_TRANSPARENT);

        self.renderItems({
            :items => items,
            :direction => Components.ListItemsDerection.RIGHT,
            :drawContext => drawContext
        });
    }
}
