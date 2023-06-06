import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Services;
import SettingsModule;
import SettingsModule.SettingType;
import SensorTypes;
import Components;

typedef SensorsInfoProps as Components.ListProps or
    {
    :fields as Array<SettingType.Enum>?
};

class SensorsInfoView extends Components.List {
    var _sensors as Array<SensorTypes.Enum> = [] as Array<SensorTypes.Enum>;
    var _fields as Array<SettingType.Enum> = [] as Array<SettingType.Enum>;

    function initialize(params as SensorsInfoProps) {
        var fields = params.get(:fields);
        self._fields = fields != null ? fields : [];
        self._updateSensors();

        List.initialize(params);
    }

    function _updateSensors() as Void {
        self._sensors = [] as Array<SensorTypes.Enum>;

        for (var i = 0; i < self._fields.size(); i++) {
            var fieldType = self._fields[i];

            self._sensors.add(SettingsModule.getValue(fieldType) as SensorTypes.Enum);
        }
    }

    function onSettingsChanged() as Void {
        Components.List.onSettingsChanged();

        self._updateSensors();
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

    protected function render(drawContext as Dc) as Void {
        var items = [] as Array<Components.ItemType>;

        for (var i = 0; i < self._sensors.size(); i++) {
            var sensorType = self._sensors[i] as SensorTypes.Enum;

            if (sensorType == SensorTypes.NONE) {
                items.add({
                    :text => null,
                    :icon => null
                });
            } else {
                items.add(self.getSensorItem(sensorType));
            }
        }

        drawContext.setColor(self.infoColor, Graphics.COLOR_TRANSPARENT);

        self.renderItems({
            :items => items,
            :direction => Components.ListItemsDerection.LEFT,
            :drawContext => drawContext
        });
    }
}
