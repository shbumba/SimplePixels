import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Services;
import SettingsModule;
import SettingsModule.SettingType;
import ColorsModule;
import SensorTypes;
import Components;

class InfoBarView extends Components.Box {
    private var _sensorType as SensorTypes.Enum = SensorTypes.NONE;
    private var _barColor as Number = 0;
    private var _sensorToGoalMap = {
        SensorTypes.BATTERY => SensorTypes.BATTERY_GOAL,
        SensorTypes.ACTIVE_MINUTES_WEEK => SensorTypes.ACTIVE_MINUTES_WEEK_GOAL,
        SensorTypes.FLOORS => SensorTypes.FLOORS_CLIMBED_GOAL,
        SensorTypes.STEPS => SensorTypes.STEPS_GOAL
    };

    function initialize(params as Components.BoxProps) {
        Components.Box.initialize(params);

        self.updateSettings();
    }

    function onSettingsChanged() as Void {
        Components.Box.onSettingsChanged();

        self.updateSettings();
    }

    private function updateSettings() as Void {
        self._barColor = ColorsModule.getColor(
            SettingsModule.getValue(SettingType.SEPARATOR_COLOR) as ColorsTypes.Enum
        );
        self._sensorType = SettingsModule.getValue(SettingType.SEPARATOR_INFO) as SensorTypes.Enum;

        DotPattern.update(DotPattern.INFO_BAR, self.getWidth(), self.getHeight(), self._barColor);
    }

    private function calculatePercente(curentValue as Number?, maxValue as Number?) as Float or Number {
        if (curentValue == 0 || curentValue == null || maxValue == 0 || maxValue == null) {
            return 0;
        }

        var result = curentValue.toFloat() / (maxValue.toFloat() / 100);

        return result > 100 ? 100 : result;
    }

    private function getGoal(sensorKey as SensorTypes.Enum) as Number? {
        var sensorGoal = self._sensorToGoalMap.get(sensorKey);

        if (sensorGoal == null) {
            return null;
        }

        return Services.SensorInfo().getValue(sensorGoal);
    }

    protected function render(drawContext as Dc) as Void {
        var width = self.getWidth();
        var height = self.getHeight();
        var posX = self.getPosX();
        var posY = self.getPosY();

        var sensorValue = Services.SensorInfo().getValue(self._sensorType);
        var maxValue = self.getGoal(self._sensorType);
        var percent = self.calculatePercente(sensorValue, maxValue);
        var isCompleted = percent.toNumber() == 100;

        var barHeight = height.toFloat() * (percent / 100);
        var valueBarShift = height - barHeight;
        
        if (!isCompleted) {
            var pattern = DotPattern.get(DotPattern.INFO_BAR, width, height, self._barColor);
            drawContext.drawBitmap(posX, posY, pattern);
        }

        drawContext.setColor(self._barColor, Graphics.COLOR_TRANSPARENT);
        drawContext.fillRectangle(posX, posY + valueBarShift, width, barHeight);
    }
}
