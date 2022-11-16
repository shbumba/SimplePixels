import Toybox.Lang;
import Toybox.Graphics;

module DotPattern {
    enum Keys {
        HOURS = 2,
        INFO_BAR
    }

    var patterns = {} as Dictionary<Keys, BufferedBitmap>;
    var PATTERN_SIZE = 2;
    var PATTERN_HEIGHT = 8;
    var IS_NEW_SDK = Graphics has :createBufferedBitmap;

    function _generateRow(width as Numeric, color as Numeric) as BufferedBitmap {
        var bitmap = createBitmap({
            :width => width,
            :height => PATTERN_HEIGHT
        });
        var dc = bitmap.getDc();

        dc.clear();
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);

        var shiftY = 0;

        for (var posX = 0; posX <= width; posX++) {
            for (var posY = shiftY; posY <= PATTERN_HEIGHT; posY += PATTERN_SIZE) {
                dc.drawPoint(posX, posY);
            }

            shiftY = shiftY == 0 ? 1 : 0;
        }

        return bitmap;
    }

    function _create(width as Numeric, height as Numeric, color as Number) as BufferedBitmap {
        var bitmap = createBitmap({
            :width => width,
            :height => height
        });

        var rowPattern = self._generateRow(width, color);
        var dc = bitmap.getDc();
        
        dc.clear();

        var rows = Toybox.Math.ceil(height / PATTERN_HEIGHT);

        for (var i = 0; i <= rows; i++) {
            var yShift = PATTERN_HEIGHT * i;

            dc.drawBitmap(0, yShift, rowPattern);
        }

        return bitmap;
    }

    function update(key as Keys, width as Numeric, height as Numeric, color as Number?) as Void {
        if (!IS_NEW_SDK) {
            return;
        }

        patterns.put(key, _create(width, height, color));
    }

    function get(key as Keys, width as Numeric, height as Numeric, color as Number?) as BufferedBitmap {
        if (!IS_NEW_SDK) {
            return _create(width, height, color);
        }

        if (!patterns.hasKey(key)) {
            update(key, width, height, color);
        }

        return patterns.get(key) as BufferedBitmap;
    }
}
