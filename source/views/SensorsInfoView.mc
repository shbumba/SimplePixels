import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Services;
import Services.ServiceType;
import SensorInfoModule.SensorType;

class SensorsInfoView extends Component.List {
    private var _sensors as Array<String>;
    private var _fields as Array<String>;

    function initialize(params as Dictionary<String, String?>) {
        self._fields = params.hasKey(:fields) ? params.get(:fields) : [];
        self.updateSensors();

        List.initialize(params);
    }

    private function updateSensors() as Void {
        self._sensors = [];

        for (var i = 0; i < self._fields.size(); i++) {
            var fieldType = self._fields[i];

            self._sensors.add(SettingsModule.getValue(fieldType));
        }
    }

    function onSettingsChanged() {
        Component.List.onSettingsChanged();

        self.updateSensors();
    }

    private function getSensorItem(sensorType as SensorType) as Component.ItemsRenderProps {
        var sensorService = Services.get(ServiceType.SENSORS_INFO);
        
        var text = sensorService.transformValue(sensorType);
        var icon = sensorService.getIcon(sensorType);

        if (sensorType == SensorType.BATTERY_IN_DAYS) {
            icon = sensorService.getIcon(SensorType.BATTERY);
        }

        return {
            :text => text,
            :icon => icon,
        };
    }

    protected function render(drawContext as Dc) as Void {
        var position = self.getPosition();
        var posX = position.get(:x);
        var posY = position.get(:y);

        var sensorService = Services.get(ServiceType.SENSORS_INFO);
        var items = [];

        for (var i = 0; i < self._sensors.size(); i++) {
            var sensorType = self._sensors[i];

            if (sensorType == SensorType.NONE) {
                items.add({
                    :text => null,
                    :icon => null
                });
            } else {
                items.add(self.getSensorItem(self._sensors[i]));
            }
        }

        var backgroundColor = Graphics.COLOR_TRANSPARENT;
        var textColor = self.textColor;
        var boxSize = self.getActualBoxSize();

        drawContext.setColor(textColor, backgroundColor);
        
        self.renderItems({
            :items => items,
            :posX => posX,
            :posY => posY,
            :drawContext => drawContext,
            :direction => Component.ListItemsDerection.get(:left)
        });
    }
}
