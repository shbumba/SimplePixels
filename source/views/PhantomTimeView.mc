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
    private var _patternTrans as Number? = null;

    function initialize(params as PhantomTimeViewProps) {
        Components.TimeView.initialize(params);

        self.updatePatterntTrans();
        var timeShift = params.get(:timeShift);
        self._timeShift = timeShift != null ? timeShift : 0;
    }

    function onSettingsChanged() as Void {
        Components.TimeView.onSettingsChanged();

        self.updatePatterntTrans();

        if (self._patternTrans != null && self._patternTrans == 100) {
            return;
        }

        DotPattern.create(
            DotPattern.HOURS,
            self.getWidth(),
            self.getHeight(),
            self.backgroundColor,
            self.foregroundColor,
            self._patternTrans
        );
    }

    private function updatePatterntTrans() as Void {
        self._patternTrans = SettingsModule.getValue(SettingType.DOT_HOUR_TRANS);
        if (!GlobalKeys.CAN_CREATE_COLOR && self._patternTrans > 0) {
            self._patternTrans = 100;
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
        if (self._patternTrans != null && self._patternTrans == 100) {
            return;
        }

        var time = self.shiftTime(self.getTime());

        self.renderTime(time, drawContext);

        var pattern = DotPattern.get(
            DotPattern.HOURS,
            self.getWidth(),
            self.getHeight(),
            self.backgroundColor,
            self.foregroundColor,
            self._patternTrans
        );

        drawContext.drawBitmap(self.getPosX(), self.getPosY(), pattern);
    }
}
