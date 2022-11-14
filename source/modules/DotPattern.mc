
import Toybox.Lang;
import Toybox.Graphics;

module DotPattern {
    var pattern as BufferedBitmap? = null;
    var PATTERN_SIZE = 2;

    function _generateRow(width as Number, color as Number) as BufferedBitmap {
        var bitmap = createBitmap({
            :width => width,
            :height => PATTERN_SIZE
        });
        var dc = bitmap.getDc();

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);

        for (var i = 1; i <= width; i++) {
            var yPos = i % 2 == 0 ? 1 : 0;

            dc.drawPoint(i, yPos);
        }

        return bitmap;
    }

    function _create(width as Number, height as Number, color as Number?) as BufferedBitmap {
        var bitmap = createBitmap({
            :width => width,
            :height => height
        });

        color = color != null ? color : Graphics.COLOR_TRANSPARENT;

        var xPos = 0;
        var yPos = 0;
        var rows = height / PATTERN_SIZE;

        var rowPattern = self._generateRow(width, color);
        var dc = bitmap.getDc();

        for (var i = 1; i <= rows; i++) {
            var yShift = i == 1 ? yPos : yPos + PATTERN_SIZE * (i - 1);

            dc.drawBitmap(xPos, yShift, rowPattern);
        }

        return bitmap;
    }

    function update(width as Number, height as Number, color as Number?) as Void {
        pattern = _create(width, height, color);
    }
}
