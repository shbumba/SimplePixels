import Toybox.Lang;
import Toybox.System;
import Toybox.Graphics;

module GlobalKeys {
    const ICON_SYMBOL = " ";
    const SCREEN_WIDTH = System.getDeviceSettings().screenWidth;
    const SCREEN_HEIGHT = System.getDeviceSettings().screenHeight;
    const IS_NEW_SDK = Graphics has :createBufferedBitmap;
    const IS_CACHE_ENABLED = System.getSystemStats().totalMemory >= 10500;
}