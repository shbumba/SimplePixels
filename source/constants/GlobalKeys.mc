import Toybox.Lang;
import Toybox.System;
import Toybox.Graphics;

module GlobalKeys {
    var SCREEN_WIDTH = 0;
    var SCREEN_HEIGHT = 0;
    var IS_24_HOUR = true;
    var DISTANCE_UNITS = System.UNIT_METRIC;
    var TEMPERATURE_UNITS = System.UNIT_METRIC;

    const ICON_SYMBOL = " ";
    const IS_NEW_SDK = Graphics has :createBufferedBitmap;
    const IS_CACHE_ENABLED = System.getSystemStats().totalMemory >= 105000;

    function initSettings() as Void {
        var settings = System.getDeviceSettings();

        SCREEN_WIDTH = settings.screenWidth;
        SCREEN_HEIGHT = settings.screenHeight;
        IS_24_HOUR = settings.is24Hour;
        DISTANCE_UNITS = settings.distanceUnits;
        TEMPERATURE_UNITS = settings.temperatureUnits;
    }
}