import Toybox.Lang;
import Toybox.System;
import Toybox.Graphics;

module GlobalKeys {
    var SCREEN_WIDTH = 0;
    var SCREEN_HEIGHT = 0;
    var IS_24_HOUR = true;
    var DISTANCE_UNITS = System.UNIT_METRIC;
    var TEMPERATURE_UNITS = System.UNIT_METRIC;
    var IS_AMOLED = false;
    var DISPLAY_MODEL = null;
    var AMOLED_Y_OFFSET = 0.0;

    const ICON_SYMBOL = " ";
    const IS_NEW_SDK = Graphics has :createBufferedBitmap;
    const IS_CACHE_ENABLED = IS_NEW_SDK && System.getSystemStats().totalMemory >= 105000;

    // Some king of optimisation for older devices, because it has to call the getDeviceSettings as few times as possible
    function initSettings() as Void {
        var settings = System.getDeviceSettings();

        SCREEN_WIDTH = settings.screenWidth;
        SCREEN_HEIGHT = settings.screenHeight;
        IS_AMOLED = SCREEN_WIDTH >= 320;
        IS_24_HOUR = settings.is24Hour;
        DISTANCE_UNITS = settings.distanceUnits;
        TEMPERATURE_UNITS = settings.temperatureUnits;
        DISPLAY_MODEL = System has :getDisplayMode ? System.getDisplayMode() : null;
        AMOLED_Y_OFFSET = SCREEN_HEIGHT > 280.0 ? SCREEN_HEIGHT * (10.0 / 360.0) : 0.0;
    }
}
