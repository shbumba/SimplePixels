import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Services;
import Services.ServiceType;
import SensorInfoModule.SensorType;
import SettingsModule;
import SettingsModule.SettingType;
import ColorsModule;

class InfoBarView extends Component.Box {
    private var _sensorType as String;
    private var _barColor as Number;
    private var _sensorToGoalMap = {
        SensorType.BATTERY => SensorType.BATTERY_GOAL,
        SensorType.ACTIVE_MINUTES_WEEK => SensorType.ACTIVE_MINUTES_WEEK_GOAL,
        SensorType.FLOORS => SensorType.FLOORS_CLIMBED_GOAL,
        SensorType.STEPS => SensorType.STEPS_GOAL,
    };

    function initialize(params as Component.BoxProps) {
        Component.Box.initialize(params);

        self.updateSettings();
    }

    function onSettingsChanged() {
        Component.Box.onSettingsChanged();

        self.updateSettings();
    }

    private function updateSettings() as Void {
        self._barColor = ColorsModule.getColor(SettingsModule.getValue(SettingType.SEPARATOR_COLOR));
        self._sensorType = SettingsModule.getValue(SettingType.SEPARATOR_INFO);
    }

    private function calculatePercente(curentValue as Number or Null, maxValue as Number or Null) as Float {
        if (curentValue == 0 || curentValue == null || maxValue == 0 || maxValue == null) {
            return 0;
        }

        var result = curentValue.toFloat() / (maxValue.toFloat() / 100);

        return result > 100 ? 100 : result;
    }

    private function getGoal(sensorKey as SensorType) as Number {
        var sensorGoal = self._sensorToGoalMap.get(sensorKey);

        if (sensorGoal == null) {
            return null;
        }

        return Services.get(ServiceType.SENSORS_INFO).getValue(sensorGoal);
    }    

    protected function render(drawContext as Dc) as Void {
        var position = self.getPosition();
        var posX = position.get(:x);
        var posY = position.get(:y);

        var sensorValue = Services.get(ServiceType.SENSORS_INFO).getValue(self._sensorType);
        var maxValue = self.getGoal(self._sensorType);
        var percent = self.calculatePercente(sensorValue, maxValue);

        var backgroundColor = Graphics.COLOR_TRANSPARENT;
        var foregroundColor = self._barColor;

        var boxSize = self.getActualBoxSize();
        var width = boxSize.get(:width);
        var height = boxSize.get(:height);
        var barHeight = height.toFloat() * (percent / 100);
        var valueBarShift = height - barHeight.toNumber();

        drawContext.setColor(foregroundColor, backgroundColor);
        drawContext.fillRectangle(posX, posY + valueBarShift, width, barHeight.toNumber());
    }
}
