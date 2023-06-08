import Toybox.Lang;
import Toybox.Graphics;

module DotPattern {
    enum Keys {
        HOURS = 2,
        INFO_BAR
    }

    var patterns = {} as Dictionary<Keys, BufferedBitmap>;
    var IS_NEW_SDK = Graphics has :createBufferedBitmap;
    const PATTERN_WIDTH = 10;
    const PATTERN_HEIGHT = 10;

    function _createBitmap(width as Numeric, height as Numeric, bgColor as Numeric, fgColor as Numeric) as BufferedBitmap {
        return $.createBitmap({
            :width => width,
            :height => height,
            :palette => IS_NEW_SDK ? [] : [Graphics.COLOR_TRANSPARENT, bgColor, fgColor]
        });
    }

    function _getDrawContext(bitmap as BufferedBitmap) as Dc {
        var drawContext = bitmap.getDc();

        drawContext.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
        drawContext.clear();

        return drawContext;
    }

    function _generatePattern(bgColor as Numeric, fgColor as Numeric) as BufferedBitmap {
        var bitmap = _createBitmap(PATTERN_WIDTH, PATTERN_HEIGHT, bgColor, fgColor);
        var drawContext = _getDrawContext(bitmap);

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
        var drawContext = _getDrawContext(bitmap);

        var columns = Toybox.Math.ceil(width / PATTERN_WIDTH);

        for (var i = 0; i <= columns; i++) {
            var posX =  i * PATTERN_WIDTH;
    
            drawContext.drawBitmap(posX, 0, pattern);
        }

        return bitmap;
    }

    function _create(width as Numeric, height as Numeric, bgColor as Numeric, fgColor as Numeric) as BufferedBitmap {
        var rowPattern = _generateRow(width, bgColor, fgColor);
        var bitmap = _createBitmap(width, height, bgColor, fgColor);
        var drawContext = _getDrawContext(bitmap);

        var rows = Toybox.Math.ceil(height / PATTERN_HEIGHT);

        for (var i = 0; i <= rows; i++) {
            var posY =  i * PATTERN_HEIGHT;

            drawContext.drawBitmap(0, posY, rowPattern);
        }

        return bitmap;
    }

    function create(key as Keys, width as Numeric, height as Numeric, bgColor as Numeric, fgColor as Numeric) as Void {
        if ($.IS_LOW_MEMORY || !IS_NEW_SDK) {
            return;
        }
        
        patterns.remove(key);

        patterns.put(key, _create(width, height, bgColor, fgColor));
    }

    function createInNeeded(key as Keys, width as Numeric, height as Numeric, bgColor as Numeric, fgColor as Numeric) as Void {
        if (!patterns.hasKey(key)) {
            create(key, width, height, bgColor, fgColor);
        }
    }

    function get(key as Keys, width as Numeric, height as Numeric, bgColor as Numeric, fgColor as Numeric) as BufferedBitmap {
        if ($.IS_LOW_MEMORY || !IS_NEW_SDK) {
            return _create(width, height, bgColor, fgColor);
        }

        createInNeeded(key, width, height, bgColor, fgColor);

        return patterns.get(key) as BufferedBitmap;
    }
}
