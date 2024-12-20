import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import SettingsModule;
import SettingsModule.SettingType;

module TimeStackModule {
    enum Enum {
        MAIN = 1,
        OFFSET
    }

    var Map =
        ({
            MAIN => :_getMainTime,
            OFFSET => :_getOffsetTime
        }) as Dictionary<Enum, Symbol>;

    function _getMainTime() {
        return Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
    }

    function _getOffsetTime() as Gregorian.Info {
        var timeZone = SettingsModule.getValue(SettingType.SECOND_TIME_FORMAT) as Number;
        var currentTime = Time.now();
        var offsetTime = currentTime.add(new Time.Duration(timeZone * 60 * 60));

        return Gregorian.utcInfo(offsetTime, Time.FORMAT_MEDIUM);
    }

    function currentTime() as Gregorian.Info {
        return get(MAIN);
    }

    function secondTime() as Gregorian.Info {
        return get(OFFSET);
    }

    function get(timeType as TimeStackModule.Enum) as Gregorian.Info {
        var timeFn = Map.get(timeType);

        var method = new Lang.Method(self, timeFn);

        return method.invoke() as Gregorian.Info;
    }
}
