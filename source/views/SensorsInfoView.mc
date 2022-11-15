import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Services;
import SettingsModule;
import SettingsModule.SettingType;
import SensorInfoModule.SensorType;

typedef SensorsInfoProps as Component.ListProps or
    {
    :fields as Array<SettingType.Enum>?
};

class SensorsInfoView extends Component.List {
    private var _sensors as Array<SensorType.Enum> = [] as Array<SensorType.Enum>;
    private var _fields as Array<SettingType.Enum> = [] as Array<SettingType.Enum>;

    function initialize(params as SensorsInfoProps) {
        var fields = params.get(:fields);
        self._fields = fields != null ? fields : [];
        self.updateSensors();

        List.initialize(params);
    }

    private function updateSensors() as Void {
        self._sensors = [] as Array<SensorType.Enum>;

        for (var i = 0; i < self._fields.size(); i++) {
            var fieldType = self._fields[i];

            self._sensors.add(SettingsModule.getValue(fieldType) as SensorType.Enum);
        }
    }

    function onSettingsChanged() {
        Component.List.onSettingsChanged();

        self.updateSensors();
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

    protected function render(drawContext as Dc) as Void {
        var sensorService = Services.SensorInfo();
        var items = [] as Array<Component.ItemType>;

        for (var i = 0; i < self._sensors.size(); i++) {
            var sensorType = self._sensors[i] as SensorType.Enum;

            if (sensorType == SensorType.NONE) {
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
            :direction => Component.ListItemsDerection.LEFT,
            :drawContext => drawContext
        });
    }
}
