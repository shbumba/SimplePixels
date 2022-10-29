import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;

module SensorInfoModule {
    module SensorsDisplay {
        typedef SensorDisplayItem as Array; // [transform as Method, title as Resource, icon as Method]

        var SensorsDictionary as Dictionary<SensorType, SensorDisplayItem> = {
            SensorType.NONE => [:transformToEmpty, Rez.Strings.None, :emptyIcon],
            SensorType.BATTERY => [:transformPercent, Rez.Strings.Battery, :batteryIcon],
            SensorType.BATTERY_IN_DAYS => [:transformBatteryInDays, Rez.Strings.BatteryInDays, :batteryIcon],
            SensorType.CURRENT_WEATHER => [:transformTemperature, Rez.Strings.Weather, :currentWeatherIcon],
            SensorType.STEPS => [:transformToFourNumbers, Rez.Strings.Steps, :stepsIcon],
            SensorType.CALORIES => [:transformToFourNumbers, Rez.Strings.Calories, :caloriesIcon],
            SensorType.HEART_RATE => [:transformToThreeNumbers, Rez.Strings.HeartRate, :heartRateIcon],
            SensorType.STRESS => [:transformPercent, Rez.Strings.Stress, :stressIcon],
            SensorType.BODY_BATTERY => [:transformPercent, Rez.Strings.BodyBattery, :bodyBatteryIcon],
            SensorType.OXYGEN_SATURATION => [:transformPercent, Rez.Strings.OxygenSaturation, :oxygenSaturationIcon],
            SensorType.RESPIRATION_RATE => [:transformRespirationRate, Rez.Strings.RespirationRate, :oxygenSaturationIcon],
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
            SensorType.MEMORY_USED => [:transformBytesToKb, Rez.Strings.Memory, :memoryIcon],
        };

        module Handlers {
            function transformToEmpty(value as Object) as String {
                return "";
            }

            function transformBytesToKb(value as Number) as String {
                value = value.toFloat() / 1024;

                return value.format("%.1f") + " kb";
            }

            function transformFullNumbers(value as Number) as String {
                return value.toString();
            }

            function transformToTwoNumbers(value as Number) as String {
                return value.format("%02d");
            }

            function transformToThreeNumbers(value as Number) as String {
                return value.format("%03d");
            }

            function transformToFourNumbers(value as Number) as String {
                return value.format("%04d");
            }

            function transformTemperature(value as Number) as String {
                var tempUnits = System.getDeviceSettings().temperatureUnits;

                if (tempUnits == System.UNIT_STATUTE) {
                    value = Math.floor(value * 1.8 + 32).toNumber();
                }

                return value.toString() + "°";
            }

            function transformPercent(value as Number) as String {
                return value.toString() + " %";
            }

            function transformBatteryInDays(value as Number) as String {
                return value.toString() + " d";
            }

            function transformPressure(value as Number) as String {
                value = value / 133.322;

                return transformToThreeNumbers(value) + " mmHg";
            }

            function transformTimeToRecovery(value as Number) as String {
                return value.toString() + " h";
            }

            function transformRespirationRate(value as Number) as String {
                return value.toString() + " b/m";
            }

            function transformMetrToFeet(value as Number) as Number {
                return value * 3.280839895;
            }

            function transformMetrToMil(value as Number) as Number {
                return value * 0.000621;
            }

            function transformMeters(value as Number) as String {
                var distanceUnits as System.UnitsSystem = System.getDeviceSettings().distanceUnits;
                
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
        }

        module Icons {
            function emptyIcon(value as Object?) as String {
                return "";
            }

            function stepsIcon(value as Object?) as String {
                return "1";
            }

            function caloriesIcon(value as Object?) as String {
                return "2";
            }

            function temperatureIcon(value as Object?) as String {
                return "3";
            }

            function batteryIcon(value as Object?) as String {
                if (value == null || value == true || value >= 85) {
                    return "4"; // 100%
                } else if (value >= 65) {
                    return "5"; // 75%
                } else if (value >= 45) {
                    return "6"; // 50%
                } else if (value >= 15) {
                    return "7"; // 25%
                }

                return "8"; // 0%
            }

            function solarIcon(value as Object?) as String {
                return "9";
            }

            function isConnectedIcon(value as Object?) as String {
                return value ? "a" : "";
            }

            function heartRateIcon(value as Object?) as String {
                return "b";
            }

            function floorsIcon(value as Object?) as String {
                return "c";
            }

            function altitudeIcon(value as Object?) as String {
                return "d";
            }

            function messagesIcon(value as Object?) as String {
                return "e";
            }

            function alarmCountIcon(value as Object?) as String {
                return "f";
            }

            function memoryIcon(value as Object?) as String {
                return "g";
            }

            function currentWeatherIcon(value as Object?) as String {
                return "h";
            }

            function oxygenSaturationIcon(value as Object?) as String {
                return "i";
            }

            function pressureIcon(value as Object?) as String {
                return "j";
            }

            function timeToRecoveryIcon(value as Object?) as String {
                return "k";
            }

            function isNightModeIcon(value as Object?) as String {
                return value ? "l" : "";
            }

            function isDoNotDisturbIcon(value as Object?) as String {
                return value ? "m" : "";
            }

            function distanceIcon(value as Object?) as String {
                return "n";
            }

            function activeMinutesDayIcon(value as Object?) as String {
                return "o";
            }

            function bodyBatteryIcon(value as Object?) as String {
                return "p";
            }

            function isChargingIcon(value as Object?) as String {
                return value ? "p" : "";
            }

            function stressIcon(value as Object?) as String {
                return "q";
            }
        }

        function getItem(sensorType as SensorType) as SensorDisplayItem {
            var sensorItem = SensorsDictionary.get(sensorType);

            if (sensorItem == null) {
                throw new Toybox.Lang.InvalidValueException("the item sensor prop has an incorrect value");
            }

            return sensorItem;
        }

        function transformValue(sensorType as SensorType, value as Object?) as String {
            if (value == null) {
                return WatchUi.loadResource(Rez.Strings.NA);
            }

            var handler = getItem(sensorType)[0];
            var method = new Lang.Method(Handlers, handler);

            return method.invoke(value);
        }

        function getText(sensorType as SensorType) as String {
            var resource = getItem(sensorType)[1];

            return WatchUi.loadResource(resource);
        }

        function getIcon(sensorType as SensorType, value as Object?) as String {
            var handler = getItem(sensorType)[2];
            var method = new Lang.Method(Icons, handler);

            return method.invoke(value);
        }
    }
}
