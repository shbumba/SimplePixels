import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

typedef PatternProps as { :drawContext as Dc, :width as Number, :height as Number, :color as Number? };

class PhantomTimeView extends Component.TimeView {
    private var _timeShift as Number;
    private var _patternFont;
    private var _patternBitmap as BufferedBitmap or Null = null;
    private static var PATTERN_SIZE = 2;

    function initialize(params as Dictionary<String, String?>) {
        Component.TimeView.initialize(params);

        self._timeShift = params.hasKey(:timeShift) ? params.get(:timeShift) : 0;
        self._patternFont = WatchUi.loadResource(Rez.Fonts.pattern);
    }

    function onSettingsChanged() {
        Component.TimeView.onSettingsChanged();

        self.removePattern();
    }

    private function generatePattern(
        props as PatternProps
    ) as Void {
        var columns = props.get(:width) / PATTERN_SIZE;

        var patternString = "";

        for (var i = 1; i <= columns; i++) {
            patternString += "*";
        }
        
        return patternString;
    }

    private function createPattern(props as PatternProps) as BufferedBitmap {
        var bitmap as BufferedBitmap;
        var bitmapProps = {
            :width => props.get(:width),
            :height => props.get(:height),
        };

        if (Graphics has :createBufferedBitmap) {
            bitmap = Graphics.createBufferedBitmap(bitmapProps).get();
        } else {
            bitmap = new Graphics.BufferedBitmap(bitmapProps);
        }

        var color = props.hasKey(:color) ? props.get(:color) : Graphics.COLOR_TRANSPARENT;
        var xPos = 0;
        var yPos = 0;
        var rows = props.get(:height) / self.PATTERN_SIZE;

        var pattern = self.generatePattern(props);
        var patternDc = bitmap.getDc();

        patternDc.clearClip();

        patternDc.setColor(Graphics.COLOR_TRANSPARENT, color);

        for (var i = 1; i <= rows; i++) {
            var yShift = i == 1 ? yPos : yPos + self.PATTERN_SIZE * (i - 1);

            patternDc.drawText(xPos, yShift, self._patternFont, pattern, Graphics.TEXT_JUSTIFY_LEFT);
        }

        return bitmap;
    }

    private function setPattern(props as PatternProps) as Void {
        self._patternBitmap = self.createPattern(props);
    }

    private function removePattern() as Void {
        self._patternBitmap = null;
    }

    private function createPatternIfNeeded(props as PatternProps) as Void {
        if (self._patternBitmap == null) {
            self.setPattern(props);
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
            break;

            case Component.TimeViewType.MINUTES:
                return self.shiftMinutes(time);
            break;
        }
    }

    protected function render(drawContext as Dc) as Void {
        var position = self.getPosition();
        var boxSize = self.getActualBoxSize();

        var posX = position.get(:x);
        var posY = position.get(:y);
        var time = self.shiftTime(self.getTime());

        self.createPatternIfNeeded({
            :width => boxSize.get(:width),
            :height => boxSize.get(:height),
            :color => backgroundColor
        });

        self.renderTime(time, drawContext);
        drawContext.drawBitmap(posX, posY, self._patternBitmap);
    }
}
