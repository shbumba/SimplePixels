import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Services;
import SensorInfoModule.SensorType;
import SettingsModule;
import SettingsModule.SettingType;
import ColorsModule;

class InfoBarView extends Component.Box {
    private var _sensorType as SensorType.Enum = SensorType.NONE;
    private var _barColor as Number = 0;
    private var _sensorToGoalMap = {
        SensorType.BATTERY => SensorType.BATTERY_GOAL,
        SensorType.ACTIVE_MINUTES_WEEK => SensorType.ACTIVE_MINUTES_WEEK_GOAL,
        SensorType.FLOORS => SensorType.FLOORS_CLIMBED_GOAL,
        SensorType.STEPS => SensorType.STEPS_GOAL
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
        self._barColor = ColorsModule.getColor(
            SettingsModule.getValue(SettingType.SEPARATOR_COLOR) as ColorsTypes.Enum
        );
        self._sensorType = SettingsModule.getValue(SettingType.SEPARATOR_INFO) as SensorType.Enum;
    }

    private function calculatePercente(curentValue as Number?, maxValue as Number?) as Float or Number {
        if (curentValue == 0 || curentValue == null || maxValue == 0 || maxValue == null) {
            return 0;
        }

        var result = curentValue.toFloat() / (maxValue.toFloat() / 100);

        return result > 100 ? 100 : result;
    }

    private function getGoal(sensorKey as SensorType.Enum) as Number? {
        var sensorGoal = self._sensorToGoalMap.get(sensorKey);

        if (sensorGoal == null) {
            return null;
        }

        return Services.SensorInfo().getValue(sensorGoal);
    }

    protected function render(drawContext as Dc) as Void {
        var width = self.getWidth();
        var height = self.getHeight();

        var sensorValue = Services.SensorInfo().getValue(self._sensorType);
        var maxValue = self.getGoal(self._sensorType);
        var percent = self.calculatePercente(sensorValue, maxValue);

        var barHeight = height.toFloat() * (percent / 100);
        var valueBarShift = height - barHeight.toNumber();

        drawContext.setColor(self._barColor, Graphics.COLOR_TRANSPARENT);
        drawContext.fillRectangle(
            self.getPosX(),
            self.getPosY() + valueBarShift,
            self.getWidth(),
            barHeight.toNumber()
        );
    }
}
