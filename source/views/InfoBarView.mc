import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Services;
import SettingsModule;
import SettingsModule.SettingType;
import ColorsModule;
import ColorsModule.ColorsTypes;
import SensorTypes;
import Components;

class InfoBarView extends Components.Box {
    private var _sensorType as SensorTypesEnum = SensorTypes.NONE;
    private var _barColor as Number = 0;
    private var _sensorToGoalMap = {
        SensorTypes.BATTERY => SensorTypes.BATTERY_GOAL,
        SensorTypes.ACTIVE_MINUTES_WEEK => SensorTypes.ACTIVE_MINUTES_WEEK_GOAL,
        SensorTypes.FLOORS => SensorTypes.FLOORS_CLIMBED_GOAL,
        SensorTypes.STEPS => SensorTypes.STEPS_GOAL
    };

    function initialize(params as Components.BoxProps) {
        Components.Box.initialize(params);

        self.updateProps();
    }

    function onSettingsChanged() as Void {
        Components.Box.onSettingsChanged();

        self.updateProps();
    }

    private function updateProps() as Void {
        self._barColor = ColorsModule.getColor(
            SettingsModule.getValue(SettingType.SEPARATOR_COLOR) as ColorsTypesEnum
        );
        self._sensorType = SettingsModule.getValue(SettingType.SEPARATOR_INFO) as SensorTypesEnum;

        DotPattern.create(DotPattern.INFO_BAR, self.getWidth(), self.getHeight(), self._barColor, self.backgroundColor);
    }

    private function calculatePercent(currentValue as Number?, maxValue as Number?) as Float or Number {
        if (currentValue == 0 || currentValue == null || maxValue == 0 || maxValue == null) {
            return 0;
        }

        var result = currentValue.toFloat() / (maxValue.toFloat() / 100);

        return result > 100 ? 100 : result;
    }

    private function getGoal(sensorKey as SensorTypesEnum) as Number? {
        var sensorGoal = self._sensorToGoalMap.get(sensorKey);

        if (sensorGoal == null) {
            return null;
        }

        return Services.SensorInfo().getValue(sensorGoal) as Number?;
    }

    protected function render(drawContext as Dc) as Void {
        var width = self.getWidth();
        var height = self.getHeight();
        var posX = self.getPosX();
        var posY = self.getPosY();
        if (self.isAod) {
            drawContext.clear();
            var pattern = DotPattern.get(DotPattern.INFO_BAR, 2, height, self.aodColor, Graphics.COLOR_BLACK);
            drawContext.drawBitmap(posX, posY, pattern);
        } else {
            var sensorValue = Services.SensorInfo().getValue(self._sensorType) as Number?;
            var maxValue = self.getGoal(self._sensorType);
            var percent = self.calculatePercent(sensorValue, maxValue);
            var isCompleted = percent.toNumber() == 100;

            var barHeight = height.toFloat() * (percent / 100);
            var valueBarShift = height - barHeight;

            if (!isCompleted) {
                var pattern = DotPattern.get(DotPattern.INFO_BAR, width, height, self._barColor, self.backgroundColor);
                drawContext.drawBitmap(posX, posY, pattern);
            }

            drawContext.setColor(self._barColor, Graphics.COLOR_TRANSPARENT);
            drawContext.fillRectangle(posX, posY + valueBarShift, width, barHeight);
        }
    }

    function setAodMode(isAod as Boolean) as Void {
        self.isAod = isAod;
        self.setVisibility();
    }

    function setVisibility() as Void {
        if (self.isAod) {
            DotPattern.create(DotPattern.INFO_BAR, 2, self.getHeight(), self.aodColor, Graphics.COLOR_TRANSPARENT);
        } else {
            self.updateProps();
        }
    }
}
