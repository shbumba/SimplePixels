import Toybox.Lang;
import Toybox.System;
import Toybox.Math;
import Toybox.Time;
import Toybox.Time.Gregorian;
import SensorInfoModule.SensorType;
import SensorsGetter;

module SensorsDisplay {
    typedef SensorDisplayItem as Array; // [transform as Method, title as Resource or Null, icon as Method]

    var SensorsDictionary = {
        SensorType.NONE => [:transformToEmpty, Rez.Strings.None, null],
        SensorType.BATTERY => [:transformPercent, Rez.Strings.Battery, :batteryIcon],
        SensorType.BATTERY_IN_DAYS => [:transformBatteryInDays, Rez.Strings.BatteryInDays, :batteryIcon],
        SensorType.CURRENT_WEATHER => [:transformTemperature, Rez.Strings.Weather, Rez.Fonts.weather_icon],
        SensorType.WEATHER_FEELS => [:transformTemperature, Rez.Strings.WeatherFeels, Rez.Fonts.weather_icon],
        SensorType.WEATHER_FORECAST => [
            :transformTemperatureForecast,
            Rez.Strings.WeatherForecast,
            Rez.Fonts.weather_icon
        ],
        SensorType.SUNRISE => [:transformTime, Rez.Strings.Sunrise, Rez.Fonts.sunrise_icon],
        SensorType.SUNSET => [:transformTime, Rez.Strings.Sunset, Rez.Fonts.sunset_icon],
        SensorType.STEPS => [:transformToFourNumbers, Rez.Strings.Steps, Rez.Fonts.steps_icon],
        SensorType.CALORIES => [:transformToFourNumbers, Rez.Strings.Calories, Rez.Fonts.calories_icon],
        SensorType.HEART_RATE => [:transformToThreeNumbers, Rez.Strings.HeartRate, Rez.Fonts.heart_icon],
        SensorType.STRESS => [:transformPercent, Rez.Strings.Stress, Rez.Fonts.stress_icon],
        SensorType.BODY_BATTERY => [:transformPercent, Rez.Strings.BodyBattery, Rez.Fonts.energy_icon],
        SensorType.OXYGEN_SATURATION => [:transformPercent, Rez.Strings.OxygenSaturation, Rez.Fonts.oxygen_icon],
        SensorType.RESPIRATION_RATE => [:transformRespirationRate, Rez.Strings.RespirationRate, Rez.Fonts.oxygen_icon],
        SensorType.TIME_TO_RECOVERY => [:transformTimeToRecovery, Rez.Strings.TimeToRecovery, Rez.Fonts.recovery_icon],
        SensorType.FLOORS => [:transformToTwoNumbers, Rez.Strings.Floors, Rez.Fonts.floors_icon],
        SensorType.METERS_CLIMBED => [:transformMeters, Rez.Strings.MetersClimbed, Rez.Fonts.floors_icon],
        SensorType.DISTANCE => [:transformMeters, Rez.Strings.Distance, Rez.Fonts.distance_icon],
        SensorType.ALTITUDE => [:transformMeters, Rez.Strings.Altitude, Rez.Fonts.altitude_icon],
        SensorType.PRESSURE => [:transformPressure, Rez.Strings.Pressure, Rez.Fonts.preasure_icon],
        SensorType.ACTIVE_MINUTES_DAY => [
            :transformActiveMinutesDay,
            Rez.Strings.ActiveMinutesDay,
            Rez.Fonts.activity_icon
        ],
        SensorType.ACTIVE_MINUTES_WEEK => [
            :transformActiveMinutesDay,
            Rez.Strings.ActiveMinutesWeek,
            Rez.Fonts.activity_icon
        ],
        SensorType.MESSAGES => [:transformFullNumbers, Rez.Strings.Messages, Rez.Fonts.messages_icon],
        SensorType.ALARM_COUNT => [:transformFullNumbers, Rez.Strings.AlarmCount, Rez.Fonts.alarm_icon],
        SensorType.SOLAR_INTENSITY => [:transformPercent, Rez.Strings.SolarIntensity, Rez.Fonts.sun_icon],
        SensorType.IS_CONNECTED => [:transformToEmpty, null, :isConnectedIcon],
        SensorType.IS_DO_NOT_DISTURB => [:transformToEmpty, null, :isDoNotDisturbIcon],
        SensorType.IS_NIGHT_MODE_ENABLED => [:transformToEmpty, null, :isNightModeIcon],
        SensorType.IS_SLEEP_TIME => [:transformToEmpty, null, :isNightModeIcon],
        SensorType.MEMORY_USED => [:transformBytesToKb, Rez.Strings.Memory, Rez.Fonts.memory_icon]
    };

    module Handlers {
        function transformToEmpty(value as Object) as String {
            return "";
        }

        function transformBytesToKb(value as Float or Number) as String {
            value = value.toFloat() / 1024;

            return value.format("%.1f") + " kb";
        }

        function transformFullNumbers(value as Float or Number) as String {
            return value.toString();
        }

        function transformToTwoNumbers(value as Float or Number) as String {
            return value.format("%02d");
        }

        function transformToThreeNumbers(value as Float or Number) as String {
            return value.format("%03d");
        }

        function transformToFourNumbers(value as Float or Number) as String {
            return value.format("%04d");
        }

        function transformTemperature(value as Number) as String {
            var tempUnits = System.getDeviceSettings().temperatureUnits;

            if (tempUnits == System.UNIT_STATUTE) {
                value = Math.floor(value * 1.8 + 32).toNumber();
            }

            return value.toString() + "°";
        }

        function transformTemperatureForecast(forecast as Array<Number?>) as String {
            var low = forecast[0];
            low = low != null ? transformTemperature(low) : low;

            var high = forecast[1];
            high = high != null ? transformTemperature(high) : high;

            var lowValue = low != null ? low : ResourcesCache.get(Rez.Strings.NA);
            var highValue = high != null ? high : ResourcesCache.get(Rez.Strings.NA);

            return Lang.format("$1$ / $2$", [lowValue, highValue]);
        }

        function transformPercent(value as Number) as String {
            return value.toString() + " %";
        }

        function transformBatteryInDays(value as Number) as String {
            return value.toString() + " d";
        }

        function transformPressure(value as Float or Number) as String {
            value = value.toFloat() / 133.322;

            return transformToThreeNumbers(value) + " mmHg";
        }

        function transformTimeToRecovery(value as Number) as String {
            return value.toString() + " h";
        }

        function transformRespirationRate(value as Number) as String {
            return value.toString() + " b/m";
        }

        function transformMetrToFeet(value as Float or Number) as Float or Number {
            return value * 3.280839895;
        }

        function transformMetrToMil(value as Float or Number) as Float or Number {
            return value * 0.000621;
        }

        function transformMeters(value as Float or Number) as String {
            var distanceUnits = System.getDeviceSettings().distanceUnits;

            var unitText = "";
            var isKilometr = value >= 1000;
            var isMetricSystem = distanceUnits == System.UNIT_METRIC;

            value = value.toFloat();

            if (isKilometr) {
                unitText = isMetricSystem ? "km" : "mi";
                value = isMetricSystem ? value / 1000 : transformMetrToMil(value);
            } else {
                unitText = isMetricSystem ? "m" : "ft";
                value = isMetricSystem ? value : transformMetrToFeet(value);
            }

            return value.format("%.1f") + " " + unitText;
        }

        function transformActiveMinutesDay(value as Number) as String {
            return transformToThreeNumbers(value) + " m";
        }

        function transformTime(time as Time.Moment) as String {
            var utcTime = Gregorian.info(time, Time.FORMAT_SHORT);
            var is24hour = System.getDeviceSettings().is24Hour;

            var hour = utcTime.hour;
            var min = utcTime.min;

            if (!is24hour && hour > 12) {
                hour = hour - 12;
            }

            var formatedTime = Lang.format("$1$:$2$", [hour.format("%02u"), min.format("%02u")]);

            var typeType = utcTime.hour >= 12 ? "pm" : "am";

            return is24hour ? formatedTime : formatedTime + " " + typeType;
        }
    }

    module Icons {
        function batteryIcon(value as SersorInfoGetterValue) as Symbol {
            if (value == null || value == true || value >= 85) {
                return Rez.Fonts.battery_100_icon; // 100%
            } else if (value >= 65) {
                return Rez.Fonts.battery_75_icon; // 75%
            } else if (value >= 45) {
                return Rez.Fonts.battery_50_icon; // 50%
            } else if (value >= 15) {
                return Rez.Fonts.battery_25_icon; // 25%
            }

            return Rez.Fonts.battery_0_icon; // 0%
        }

        function isConnectedIcon(value as SersorInfoGetterValue) as Symbol? {
            return value == true ? Rez.Fonts.connection_icon : null;
        }

        function isNightModeIcon(value as SersorInfoGetterValue) as Symbol? {
            return value == true ? Rez.Fonts.sleep_icon : null;
        }

        function isDoNotDisturbIcon(value as SersorInfoGetterValue) as Symbol? {
            return value == true ? Rez.Fonts.dnd_icon : null;
        }
    }

    function getItem(sensorType as SensorType.Enum) as SensorDisplayItem {
        var sensorItem = SensorsDictionary.get(sensorType);

        if (sensorItem == null) {
            throw new Toybox.Lang.InvalidValueException("the item sensor prop has an incorrect value");
        }

        return sensorItem;
    }

    function transformValue(sensorType as SensorType.Enum, value as SersorInfoGetterValue) as String {
        if (value == null) {
            return ResourcesCache.get(Rez.Strings.NA) as String;
        }

        var handler = getItem(sensorType)[0];
        var method = new Lang.Method(Handlers, handler);

        return method.invoke(value) as String;
    }

    function getText(sensorType as SensorType.Enum) as Symbol? {
        return getItem(sensorType)[1];
    }

    function getIcon(sensorType as SensorType.Enum, value as SersorInfoGetterValue) as Symbol? {
        var iconFn = getItem(sensorType)[2];

        if (iconFn instanceof Lang.Number || iconFn == null) {
            return iconFn as Symbol?;
        }

        var method = new Lang.Method(Icons, iconFn);

        return method.invoke(value) as Symbol?;
    }
}
