import Toybox.Lang;
import Toybox.Graphics;
import Toybox.Math;

module DotPattern {
    enum Keys {
        HOURS = 1,
        INFO_BAR
    }

    var patterns = {} as Dictionary<Keys, BufferedBitmap>;
    const PATTERN_SIZE = 2;
    const PATTERN_HEIGHT = 8;
    const isCacheEnabled = canUseCache();
    const IS_NEW_SDK = Graphics has :createBufferedBitmap;

    function _generateRow(width as Numeric, bgColor as Numeric, fgColor as Numeric) as BufferedBitmap {
        var bitmap = createBitmap({
            :width => width,
            :height => PATTERN_HEIGHT,
            :palette => IS_NEW_SDK ? [] : [Graphics.COLOR_TRANSPARENT, bgColor, fgColor]
        });
        var dc = bitmap.getDc();

        dc.clear();
        dc.setColor(bgColor, Graphics.COLOR_TRANSPARENT);

        var shiftY = 0;

        for (var posX = 0; posX <= width; posX++) {
            for (var posY = shiftY; posY <= PATTERN_HEIGHT; posY += PATTERN_SIZE) {
                dc.drawPoint(posX, posY);
            }

            shiftY = shiftY == 0 ? 1 : 0;
        }

        return bitmap;
    }

    function _create(width as Numeric, height as Numeric, bgColor as Numeric, fgColor as Numeric) as BufferedBitmap {
        var bitmap = createBitmap({
            :width => width,
            :height => height,
            :palette => IS_NEW_SDK ? [] : [Graphics.COLOR_TRANSPARENT, bgColor, fgColor]
        });
        var rowPattern = self._generateRow(width, bgColor, fgColor);
        var dc = bitmap.getDc();
        
        dc.clear();
        dc.setColor(bgColor, Graphics.COLOR_TRANSPARENT);

        var rows = Toybox.Math.ceil(height / PATTERN_HEIGHT);

        for (var i = 0; i <= rows; i++) {
            var yShift = PATTERN_HEIGHT * i;

            dc.drawBitmap(0, yShift, rowPattern);
        }

        return bitmap;
    }

    function create(key as Keys, width as Numeric, height as Numeric, bgColor as Numeric, fgColor as Numeric) as Void {
        if (!isCacheEnabled) {
            return;
        }

        patterns.put(key, _create(width, height, bgColor, fgColor));
    }

    function get(key as Keys, width as Numeric, height as Numeric, bgColor as Numeric, fgColor as Numeric) as BufferedBitmap {
        if (!isCacheEnabled) {
            return _create(width, height, bgColor, fgColor);
        }

        if (!patterns.hasKey(key)) {
            create(key, width, height, bgColor, fgColor);
        }

        return patterns.get(key) as BufferedBitmap;
    }
}
