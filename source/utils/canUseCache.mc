import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

function canUseCache() as Boolean {
    return (System.getSystemStats().totalMemory >= 10000) && (Graphics has :createBufferedBitmap);
}