import Toybox.Lang;
import Toybox.Graphics;

module DotPattern {
    var pattern as BufferedBitmap? = null;
    var PATTERN_SIZE = 2;
    var PATTERN_HEIGHT = 8;
    var IS_NEW_SDK = Graphics has :createBufferedBitmap;

    function _generateRow(width as Number, color as Number) as BufferedBitmap {
        var bitmap = createBitmap({
            :width => width,
            :height => PATTERN_HEIGHT,
            :colorDepth => 8
        });
        var dc = bitmap.getDc();

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);

        for (var posX = 0; posX <= width; posX++) {
            var shift = (posX + 1) % 2 == 0 ? 1 : 0;

            for (var posY = 0; posY <= PATTERN_HEIGHT; posY += PATTERN_SIZE) {
                dc.drawPoint(posX, posY + shift);
            }
        }

        return bitmap;
    }

    function _create(width as Number, height as Number, color as Number) as BufferedBitmap {
        var bitmap = createBitmap({
            :width => width,
            :height => height,
            :colorDepth => 8
        });

        var rowPattern = self._generateRow(width, color);
        var dc = bitmap.getDc();

        var rows = Toybox.Math.ceil(height / PATTERN_HEIGHT);

        for (var i = 0; i <= rows; i++) {
            var yShift = PATTERN_HEIGHT * i;

            dc.drawBitmap(0, yShift, rowPattern);
        }

        return bitmap;
    }

    function update(width as Number, height as Number, color as Number?) as Void {
        if (!IS_NEW_SDK) {
            return;
        }

        pattern = _create(width, height, color);
    }

    function get(width as Number, height as Number, color as Number?) as BufferedBitmap {
        if (!IS_NEW_SDK) {
            return _create(width, height, color);
        } else if (pattern == null) {
            update(width, height, color);
        }

        return pattern as BufferedBitmap;
    }
}
