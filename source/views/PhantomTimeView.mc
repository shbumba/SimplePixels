import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

typedef PhantomTimeViewProps as Component.TimeViewProps or
    {
    :timeShift as Number?
};

class PhantomTimeView extends Component.TimeView {
    private var _timeShift as Number;
    private var _patternBitmap as BufferedBitmap? = null;
    private var PATTERN_SIZE = 2;

    function initialize(params as PhantomTimeViewProps) {
        Component.TimeView.initialize(params);

        self._timeShift = params.hasKey(:timeShift) ? params.get(:timeShift) : 0;
    }

    function onSettingsChanged() {
        Component.TimeView.onSettingsChanged();

        self.removePattern();
    }

    private function generatePattern(width as Number, color as Number) as BufferedBitmap {
        var bitmap = createBitmap({
            :width => width,
            :height => self.PATTERN_SIZE
        });
        var dc = bitmap.getDc();

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);

        for (var i = 1; i <= width; i++) {
            var yPos = i % 2 == 0 ? 1 : 0;

            dc.drawPoint(i, yPos);
        }

        return bitmap;
    }

    private function createPattern(width as Number, height as Number, color as Number?) as BufferedBitmap {
        var bitmap = createBitmap({
            :width => width,
            :height => height
        });

        color = color != null ? color : Graphics.COLOR_TRANSPARENT;

        var xPos = 0;
        var yPos = 0;
        var rows = height / self.PATTERN_SIZE;

        var pattern = self.generatePattern(width, color);
        var dc = bitmap.getDc();

        for (var i = 1; i <= rows; i++) {
            var yShift = i == 1 ? yPos : yPos + self.PATTERN_SIZE * (i - 1);

            dc.drawBitmap(xPos, yShift, pattern);
        }

        return bitmap;
    }

    private function setPattern(width as Number, height as Number, color as Number?) as Void {
        self._patternBitmap = self.createPattern(width, height, color);
    }

    private function removePattern() as Void {
        self._patternBitmap = null;
    }

    private function createPatternIfNeeded(width as Number, height as Number, color as Number?) as Void {
        if (self._patternBitmap == null) {
            self.setPattern(width, height, color);
        }
    }

    private function shiftHours(time as Number) as Number {
        var hours = time + self._timeShift;
        var timeFormat = self._is24hour ? 24 : 12;

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
            case Component.TimeViewType.HOURS:
                return self.shiftHours(time);

            default:
            case Component.TimeViewType.MINUTES:
                return self.shiftMinutes(time);
        }
    }

    protected function render(drawContext as Dc) as Void {
        var position = self.getPosition();
        var boxSize = self.getActualBoxSize();

        var posX = position.get(:x);
        var posY = position.get(:y);
        var width = boxSize.get(:width);
        var height = boxSize.get(:height);
        var time = self.shiftTime(self.getTime());

        self.createPatternIfNeeded(width, height, self.backgroundColor);

        self.renderTime(time, drawContext);
        drawContext.drawBitmap(posX, posY, self._patternBitmap);
    }
}
