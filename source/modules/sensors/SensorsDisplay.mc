import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Time;
import Toybox.Time.Gregorian;

module SensorInfoModule {
    module SensorsDisplay {
        typedef SensorDisplayItem as Array; // [transform as Method, title as Resource, icon as Method]

        var SensorsDictionary = {
            SensorType.NONE => [:transformToEmpty, Rez.Strings.None, :emptyIcon],
            SensorType.BATTERY => [:transformPercent, Rez.Strings.Battery, :batteryIcon],
            SensorType.BATTERY_IN_DAYS => [:transformBatteryInDays, Rez.Strings.BatteryInDays, :batteryIcon],
            SensorType.CURRENT_WEATHER => [:transformTemperature, Rez.Strings.Weather, :currentWeatherIcon],
            SensorType.WEATHER_FEELS => [:transformTemperature, Rez.Strings.WeatherFeels, :currentWeatherIcon],
            SensorType.WEATHER_FORECAST => [
                :transformTemperatureForecast,
                Rez.Strings.WeatherForecast,
                :currentWeatherIcon
            ],
            SensorType.SUNRISE => [:transformTime, Rez.Strings.Sunrise, :sunriseIcon],
            SensorType.SUNSET => [:transformTime, Rez.Strings.Sunset, :sunsetIcon],
            SensorType.STEPS => [:transformToFourNumbers, Rez.Strings.Steps, :stepsIcon],
            SensorType.CALORIES => [:transformToFourNumbers, Rez.Strings.Calories, :caloriesIcon],
            SensorType.HEART_RATE => [:transformToThreeNumbers, Rez.Strings.HeartRate, :heartRateIcon],
            SensorType.STRESS => [:transformPercent, Rez.Strings.Stress, :stressIcon],
            SensorType.BODY_BATTERY => [:transformPercent, Rez.Strings.BodyBattery, :bodyBatteryIcon],
            SensorType.OXYGEN_SATURATION => [:transformPercent, Rez.Strings.OxygenSaturation, :oxygenSaturationIcon],
            SensorType.RESPIRATION_RATE => [
                :transformRespirationRate,
                Rez.Strings.RespirationRate,
                :oxygenSaturationIcon
            ],
            SensorType.TIME_TO_RECOVERY => [:transformTimeToRecovery, Rez.Strings.TimeToRecovery, :timeToRecoveryIcon],
            SensorType.FLOORS => [:transformToTwoNumbers, Rez.Strings.Floors, :floorsIcon],
            SensorType.METERS_CLIMBED => [:transformMeters, Rez.Strings.MetersClimbed, :floorsIcon],
            SensorType.DISTANCE => [:transformMeters, Rez.Strings.Distance, :distanceIcon],
            SensorType.ALTITUDE => [:transformMeters, Rez.Strings.Altitude, :altitudeIcon],
            SensorType.PRESSURE => [:transformPressure, Rez.Strings.Pressure, :pressureIcon],
            SensorType.ACTIVE_MINUTES_DAY => [
                :transformActiveMinutesDay,
                Rez.Strings.ActiveMinutesDay,
                :activeMinutesDayIcon
            ],
            SensorType.ACTIVE_MINUTES_WEEK => [
                :transformActiveMinutesDay,
                Rez.Strings.ActiveMinutesWeek,
                :activeMinutesDayIcon
            ],
            SensorType.MESSAGES => [:transformFullNumbers, Rez.Strings.Messages, :messagesIcon],
            SensorType.ALARM_COUNT => [:transformFullNumbers, Rez.Strings.AlarmCount, :alarmCountIcon],
            SensorType.SOLAR_INTENSITY => [:transformPercent, Rez.Strings.SolarIntensity, :solarIcon],
            SensorType.TEMPERATURE => [:transformTemperature, Rez.Strings.Temperature, :temperatureIcon],
            SensorType.IS_CONNECTED => [:transformToEmpty, Rez.Strings.IsConnected, :isConnectedIcon],
            SensorType.IS_DO_NOT_DISTURB => [:transformToEmpty, Rez.Strings.IsDoNotDisturb, :isDoNotDisturbIcon],
            SensorType.IS_NIGHT_MODE_ENABLED => [:transformToEmpty, Rez.Strings.IsNightMode, :isNightModeIcon],
            SensorType.IS_SLEEP_TIME => [:transformToEmpty, Rez.Strings.IsSleepTime, :isNightModeIcon],
            SensorType.IS_CHARGING => [:transformToEmpty, Rez.Strings.IsCharging, :isChargingIcon],
            SensorType.MEMORY_USED => [:transformBytesToKb, Rez.Strings.Memory, :memoryIcon]
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
                var utcTime = Gregorian.utcInfo(time, Time.FORMAT_SHORT);
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
            function emptyIcon(value as SersorInfoGetterValue) as Null {
                return null;
            }

            function stepsIcon(value as SersorInfoGetterValue) as Symbol {
                return Rez.Fonts.steps_icon;
            }

            function caloriesIcon(value as SersorInfoGetterValue) as Symbol {
                return Rez.Fonts.calories_icon;
            }

            function temperatureIcon(value as SersorInfoGetterValue) as Symbol {
                return Rez.Fonts.temperature_icon;
            }

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

            function solarIcon(value as SersorInfoGetterValue) as Symbol {
                return Rez.Fonts.sun_icon;
            }

            function sunriseIcon(value as SersorInfoGetterValue) as Symbol {
                return Rez.Fonts.sunrise_icon;
            }

            function sunsetIcon(value as SersorInfoGetterValue) as Symbol {
                return Rez.Fonts.sunset_icon;
            }

            function isConnectedIcon(value as SersorInfoGetterValue) as Symbol? {
                return value == true ? Rez.Fonts.connection_icon : null;
            }

            function heartRateIcon(value as SersorInfoGetterValue) as Symbol {
                return Rez.Fonts.heart_icon;
            }

            function floorsIcon(value as SersorInfoGetterValue) as Symbol {
                return Rez.Fonts.floors_icon;
            }

            function altitudeIcon(value as SersorInfoGetterValue) as Symbol {
                return Rez.Fonts.altitude_icon;
            }

            function messagesIcon(value as SersorInfoGetterValue) as Symbol {
                return Rez.Fonts.messages_icon;
            }

            function alarmCountIcon(value as SersorInfoGetterValue) as Symbol {
                return Rez.Fonts.alarm_icon;
            }

            function memoryIcon(value as SersorInfoGetterValue) as Symbol {
                return Rez.Fonts.memory_icon;
            }

            function currentWeatherIcon(value as SersorInfoGetterValue) as Symbol {
                return Rez.Fonts.weather_icon;
            }

            function oxygenSaturationIcon(value as SersorInfoGetterValue) as Symbol {
                return Rez.Fonts.oxygen_icon;
            }

            function pressureIcon(value as SersorInfoGetterValue) as Symbol {
                return Rez.Fonts.preasure_icon;
            }

            function timeToRecoveryIcon(value as SersorInfoGetterValue) as Symbol {
                return Rez.Fonts.recovery_icon;
            }

            function isNightModeIcon(value as SersorInfoGetterValue) as Symbol? {
                return value == true ? Rez.Fonts.sleep_icon : null;
            }

            function isDoNotDisturbIcon(value as SersorInfoGetterValue) as Symbol? {
                return value == true ? Rez.Fonts.dnd_icon : null;
            }

            function distanceIcon(value as SersorInfoGetterValue) as Symbol {
                return Rez.Fonts.distance_icon;
            }

            function activeMinutesDayIcon(value as SersorInfoGetterValue) as Symbol {
                return Rez.Fonts.activity_icon;
            }

            function bodyBatteryIcon(value as SersorInfoGetterValue) as Symbol {
                return Rez.Fonts.energy_icon;
            }

            function isChargingIcon(value as SersorInfoGetterValue) as Symbol? {
                return value == true ? Rez.Fonts.energy_icon : null;
            }

            function stressIcon(value as SersorInfoGetterValue) as Symbol {
                return Rez.Fonts.stress_icon;
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

        function getText(sensorType as SensorType.Enum) as Symbol {
            return getItem(sensorType)[1] as Symbol;
        }

        function getIcon(sensorType as SensorType.Enum, value as SersorInfoGetterValue) as Symbol? {
            var handler = getItem(sensorType)[2];
            var method = new Lang.Method(Icons, handler);

            return method.invoke(value) as Symbol?;
        }
    }
}
