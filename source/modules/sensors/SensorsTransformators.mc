import Toybox.Lang;
import Toybox.System;
import Toybox.Math;
import Toybox.Time;
import Toybox.Time.Gregorian;
import SensorsGetters;
import SensorTypes;
import ResourcesCache;

module SensorsTransformators {
    var Map = {
        SensorTypes.NONE => :_transformToEmpty,
        SensorTypes.BATTERY => :_transformPercent,
        SensorTypes.BATTERY_IN_DAYS => :_transformBatteryInDays,
        SensorTypes.CURRENT_WEATHER => :_transformTemperature,
        SensorTypes.WEATHER_FEELS => :_transformTemperature,
        SensorTypes.WEATHER_FORECAST => :_transformTemperatureForecast,
        SensorTypes.SUNRISE => :_transformTime,
        SensorTypes.SUNSET => :_transformTime,
        SensorTypes.STEPS => :_transformToFourNumbers,
        SensorTypes.CALORIES => :_transformToFourNumbers,
        SensorTypes.HEART_RATE => :_transformToThreeNumbers,
        SensorTypes.STRESS => :_transformPercent,
        SensorTypes.BODY_BATTERY => :_transformPercent,
        SensorTypes.OXYGEN_SATURATION => :_transformPercent,
        SensorTypes.RESPIRATION_RATE => :_transformRespirationRate,
        SensorTypes.TIME_TO_RECOVERY => :_transformTimeToRecovery,
        SensorTypes.FLOORS => :_transformToTwoNumbers,
        SensorTypes.METERS_CLIMBED => :_transformMeters,
        SensorTypes.DISTANCE => :_transformMeters,
        SensorTypes.ALTITUDE => :_transformMeters,
        SensorTypes.PRESSURE => :_transformPressure,
        SensorTypes.ACTIVE_MINUTES_DAY => :_transformActiveMinutesDay,
        SensorTypes.ACTIVE_MINUTES_WEEK => :_transformActiveMinutesDay,
        SensorTypes.MESSAGES => :_transformFullNumbers,
        SensorTypes.ALARM_COUNT => :_transformFullNumbers,
        SensorTypes.SOLAR_INTENSITY => :_transformPercent,
        SensorTypes.IS_CONNECTED => :_transformToEmpty,
        SensorTypes.IS_DO_NOT_DISTURB => :_transformToEmpty,
        SensorTypes.IS_NIGHT_MODE_ENABLED => :_transformToEmpty,
        SensorTypes.IS_SLEEP_TIME => :_transformToEmpty,
        SensorTypes.SECOND_TIME => :_transformTime,
        SensorTypes.MEMORY_USED => :_transformBytesToKb
    };

    function transformValue(sensorType as SensorTypes.Enum, value as SersorInfoGetterValue) as String {
        var handler = Map.get(sensorType);

        if (value == null || handler == null) {
            return ResourcesCache.get(Rez.Strings.NA) as String;
        }

        var method = new Lang.Method(Handlers, handler);

        return method.invoke(value) as String;
    }

    module Handlers {
        function _transformToEmpty(value as Object) as String {
            return "";
        }

        function _transformBytesToKb(value as Float or Number) as String {
            value = value.toFloat() / 1024;

            return value.format("%.1f") + " kb";
        }

        function _transformFullNumbers(value as Float or Number) as String {
            return value.toString();
        }

        function _transformToTwoNumbers(value as Float or Number) as String {
            return value.format("%02d");
        }

        function _transformToThreeNumbers(value as Float or Number) as String {
            return value.format("%03d");
        }

        function _transformToFourNumbers(value as Float or Number) as String {
            return value.format("%04d");
        }

        function _transformTemperature(value as Number) as String {
            var tempUnits = System.getDeviceSettings().temperatureUnits;

            if (tempUnits == System.UNIT_STATUTE) {
                value = Math.floor(value * 1.8 + 32).toNumber();
            }

            return value.format("%.0f").toString() + "°";
        }

        function _transformTemperatureForecast(forecast as Array<Number?>) as String {
            var low = forecast[0];
            low = low != null ? _transformTemperature(low) : low;

            var high = forecast[1];
            high = high != null ? _transformTemperature(high) : high;

            var lowValue = low != null ? low : ResourcesCache.get(Rez.Strings.NA);
            var highValue = high != null ? high : ResourcesCache.get(Rez.Strings.NA);

            return Lang.format("$1$ / $2$", [lowValue, highValue]);
        }

        function _transformPercent(value as Number) as String {
            return value.toString() + " %";
        }

        function _transformBatteryInDays(value as Number) as String {
            return value.toString() + " d";
        }

        function _transformPressure(value as Float or Number) as String {
            value = value.toFloat() / 133.322;

            return _transformToThreeNumbers(value) + " mmHg";
        }

        function _transformTimeToRecovery(value as Number) as String {
            return value.toString() + " h";
        }

        function _transformRespirationRate(value as Number) as String {
            return value.toString() + " b/m";
        }

        function _transformMetrToFeet(value as Float or Number) as Float or Number {
            return value * 3.280839895;
        }

        function _transformMetrToMil(value as Float or Number) as Float or Number {
            return value * 0.000621;
        }

        function _transformMeters(value as Float or Number) as String {
            var distanceUnits = System.getDeviceSettings().distanceUnits;

            var unitText = "";
            var isKilometr = value >= 1000;
            var isMetricSystem = distanceUnits == System.UNIT_METRIC;

            value = value.toFloat();

            if (isKilometr) {
                unitText = isMetricSystem ? "km" : "mi";
                value = isMetricSystem ? value / 1000 : _transformMetrToMil(value);
            } else {
                unitText = isMetricSystem ? "m" : "ft";
                value = isMetricSystem ? value : _transformMetrToFeet(value);
            }

            return value.format("%.1f") + " " + unitText;
        }

        function _transformActiveMinutesDay(value as Number) as String {
            return _transformToThreeNumbers(value) + " m";
        }

        function _transformTime(timeInfo as Gregorian.Info) as String {
            var is24hour = System.getDeviceSettings().is24Hour;

            var hour = timeInfo.hour;
            var min = timeInfo.min;

            if (!is24hour && hour > 12) {
                hour = hour - 12;
            }

            var formatedTime = Lang.format("$1$:$2$", [hour.format("%02u"), min.format("%02u")]);

            var typeType = timeInfo.hour >= 12 ? "pm" : "am";

            return is24hour ? formatedTime : formatedTime + " " + typeType;
        }
    }
}
