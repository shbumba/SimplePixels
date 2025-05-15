import Toybox.Lang;
import Toybox.Graphics;
import Toybox.Math;
import GlobalKeys;

module DotPattern {
    enum Keys {
        HOURS = 1,
        INFO_BAR
    }

    var patterns = ({}) as Dictionary<Keys, BufferedBitmap>;
    const PATTERN_WIDTH = 10;
    const PATTERN_HEIGHT = 10;

    function _createBitmap(
        width as Numeric,
        height as Numeric,
        bgColor as Numeric,
        fgColor as Numeric
    ) as BufferedBitmap {
        return createBitmap({
            :width => width,
            :height => height,
            :palette => GlobalKeys.IS_NEW_SDK ? [] : [Graphics.COLOR_TRANSPARENT, bgColor, fgColor]
        });
    }

    /**
     * for some reason it does not work for older devices with SDK versions lower than 4.0.0
    function _getDrawContext(bitmap as BufferedBitmap, bgColor as Numeric) as Dc {
        var drawContext = bitmap.getDc();

        drawContext.setColor(bgColor, Graphics.COLOR_TRANSPARENT);
        drawContext.clear();// it doesn't work because I clear the dc after the colors are set o_0

        return drawContext;
    }*/

    function _generatePattern(bgColor as Numeric, fgColor as Numeric) as BufferedBitmap {
        var bitmap = _createBitmap(PATTERN_WIDTH, PATTERN_HEIGHT, bgColor, fgColor);
        var drawContext = bitmap.getDc();

        drawContext.setColor(bgColor, Graphics.COLOR_TRANSPARENT);

        var shiftY = 0;

        for (var posX = 0; posX <= PATTERN_WIDTH; posX++) {
            for (var posY = shiftY; posY <= PATTERN_HEIGHT; posY += 2) {
                drawContext.drawPoint(posX, posY);
            }

            shiftY = shiftY == 0 ? 1 : 0;
        }

        return bitmap;
    }

    function _generateRow(width as Numeric, bgColor as Numeric, fgColor as Numeric) as BufferedBitmap {
        var pattern = _generatePattern(bgColor, fgColor);
        var bitmap = _createBitmap(width, PATTERN_HEIGHT, bgColor, fgColor);
        var drawContext = bitmap.getDc();

        drawContext.setColor(bgColor, Graphics.COLOR_TRANSPARENT);

        var columns = Math.ceil(width / PATTERN_WIDTH).toNumber();

        for (var i = 0; i <= columns; i++) {
            var posX = i * PATTERN_WIDTH;

            drawContext.drawBitmap(posX, 0, pattern);
        }

        return bitmap;
    }

    function _create(
        width as Numeric,
        height as Numeric,
        bgColor as Numeric,
        fgColor as Numeric
    ) as BufferedBitmap {
        var bitmap = _createBitmap(width, height, bgColor, fgColor);
        var drawContext = bitmap.getDc();
        var rowPattern = _generateRow(width, bgColor, fgColor);

        drawContext.setColor(bgColor, Graphics.COLOR_TRANSPARENT);

        var rows = Math.ceil(height / PATTERN_HEIGHT);

        for (var i = 0; i <= rows; i++) {
            var yShift = PATTERN_HEIGHT * i;

            drawContext.drawBitmap(0, yShift, rowPattern);
        }

        return bitmap;
    }

    function create(
        key as Keys,
        width as Numeric,
        height as Numeric,
        bgColor as Numeric,
        fgColor as Numeric
    ) as Void {
        if (!GlobalKeys.IS_CACHE_ENABLED) {
            return;
        }

        patterns.put(key, _create(width, height, bgColor, fgColor));
    }

    function get(
        key as Keys,
        width as Numeric,
        height as Numeric,
        bgColor as Numeric,
        fgColor as Numeric
    ) as BufferedBitmap {
        if (!GlobalKeys.IS_CACHE_ENABLED) {
            return _create(width, height, bgColor, fgColor);
        }

        if (!patterns.hasKey(key)) {
            create(key, width, height, bgColor, fgColor);
        }

        return patterns.get(key) as BufferedBitmap;
    }
}
