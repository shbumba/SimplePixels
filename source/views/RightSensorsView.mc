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
    :fields as Array<SettingTypeEnum>?
};

class RightSensorsView extends Components.List {
    var _sensors as Array<SensorTypesEnum> = [] as Array<SensorTypesEnum>;
    var _fields as Array<SettingTypeEnum> = [] as Array<SettingTypeEnum>;

    function initialize(params as SensorsInfoProps) {
        var fields = params.get(:fields) as Array<SettingTypeEnum>?;
        self._fields = fields != null ? fields : [] as Array<SettingTypeEnum>;
        self._updateSensors();

        List.initialize(params);
    }

    function _updateSensors() as Void {
        self._sensors = [] as Array<SensorTypesEnum>;

        for (var i = 0; i < self._fields.size(); i++) {
            var fieldType = self._fields[i];

            self._sensors.add(SettingsModule.getValue(fieldType) as SensorTypesEnum);
        }
    }

    function onSettingsChanged() as Void {
        Components.List.onSettingsChanged();
        self._updateSensors();
    }

    private function getSensorItem(sensorType as SensorTypesEnum) as Components.ItemType {
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
            var sensorType = self._sensors[i] as SensorTypesEnum;

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
            :direction => Components.ListItemsDirection.LEFT,
            :drawContext => drawContext
        });
    }

    function setAodMode(isAod as Boolean) as Void {
        self.isAod = isAod;
        self.setVisibility();
    }

    function setVisibility() as Void {
        self.setVisible(!self.isAod);
    }
}
