import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

typedef BitmapProps as {
        :width as Lang.Number?,
        :height as Lang.Number?,
        :palette as Lang.Array<Graphics.ColorType>?,
        :colorDepth as Lang.Number?,
        :bitmapResource as WatchUi.BitmapResource or Graphics.BitmapReference,
        :alphaBlending as Graphics.AlphaBlending?
    };

function createBitmap(props as BitmapProps) as BufferedBitmap {
    if (Graphics has :createBufferedBitmap) {
        return Graphics.createBufferedBitmap(props).get();
    } else {
        return new Graphics.BufferedBitmap(props);
    }
}