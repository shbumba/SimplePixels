import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import DotPattern;
import Components;
import GlobalKeys;
import SettingsModule;
import SettingsModule.SettingType;

typedef PhantomTimeViewProps as Components.TimeViewProps or
    {
    :timeShift as Number?
};

class PhantomTimeView extends Components.TimeView {
    private var _timeShift as Number;
    private var _isPatternEnabled as Boolean = true;

    function initialize(params as PhantomTimeViewProps) {
        Components.TimeView.initialize(params);

        self.updatePatternTrans();
        var timeShift = params.get(:timeShift);
        self._timeShift = timeShift != null ? timeShift : 0;
    }

    function onSettingsChanged() as Void {
        Components.TimeView.onSettingsChanged();

        self.updatePatternTrans();

        if (self._isPatternEnabled) {
            DotPattern.create(
                DotPattern.HOURS,
                self.getWidth(),
                self.getHeight(),
                self.backgroundColor,
                self.foregroundColor
            );
        }
    }

    private function updatePatternTrans() as Void {
        var alphaColor = SettingsModule.getValue(SettingType.DOT_HOUR_TRANS);
        var shouldApplyAlphaColor = alphaColor != null && alphaColor > 0 && alphaColor < 100;

        self._isPatternEnabled = alphaColor != null && alphaColor != 100;

        if (shouldApplyAlphaColor) {
            var fgColor = getSettingColor(SettingType.FOREGROUND_COLOR);
            self.foregroundColor = blendColors(fgColor, self.backgroundColor, alphaColor);
        } else {
            self.setColors();
        }
    }

    private function shiftHours(time as Number) as Number {
        var hours = time + self._timeShift;
        var timeFormat = GlobalKeys.IS_24_HOUR ? 24 : 12;

        if (hours > timeFormat) {
            hours -= timeFormat;
        } else if (hours < 0) {
            hours += timeFormat;
        }

        return hours;
    }

    private function shiftMinutes(time as Number) as Number {
        var newTime = time + self._timeShift;

        if (newTime > 60) {
            newTime -= 60;
        } else if (newTime < 0) {
            newTime += 60;
        }

        return newTime;
    }

    private function shiftTime(time as Number) as Number {
        switch (self._timeType) {
            case Components.TimeViewType.HOURS:
                return self.shiftHours(time);

            default:
            case Components.TimeViewType.MINUTES:
                return self.shiftMinutes(time);
        }
    }

    protected function render(drawContext as Dc) as Void {
        if (self._isPatternEnabled == false) {
            return;
        }

        var time = self.shiftTime(self.getTime());

        self.renderTime(time, drawContext);

        var pattern = DotPattern.get(
            DotPattern.HOURS,
            self.getWidth(),
            self.getHeight(),
            self.backgroundColor,
            self.foregroundColor
        );

        drawContext.drawBitmap(self.getPosX(), self.getPosY(), pattern);
    }
}
