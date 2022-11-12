import Toybox.Lang;
import Toybox.System;
import Toybox.ActivityMonitor;
import Toybox.Activity;
import Toybox.SensorHistory;
import Toybox.Math;
import Toybox.Weather;
import Toybox.UserProfile;
import Toybox.Time;
import Toybox.Position;
import SensorInfoModule.SensorType;

module SensorsGetter {
    typedef SersorInfoGetterValue as Number or Float or Boolean or Time.Moment or Position.Info or Null;

    var SensorsDictionary as Dictionary<SensorType.Enum, Symbol> =
        {
            SensorType.NONE => :getNone,
            SensorType.BATTERY => :getBattery,
            SensorType.BATTERY_IN_DAYS => :getBatteryInDays,
            SensorType.CURRENT_WEATHER => :getCurrentWeather,
            SensorType.WEATHER_FEELS => :getWeatherFeels,
            SensorType.WEATHER_FORECAST => :getCurrentForecast,
            SensorType.SUNRISE => :getSunrise,
            SensorType.SUNSET => :getSunset,
            SensorType.STEPS => :getSteps,
            SensorType.CALORIES => :getCalories,
            SensorType.HEART_RATE => :getHR,
            SensorType.STRESS => :getStress,
            SensorType.BODY_BATTERY => :getBodyBattery,
            SensorType.OXYGEN_SATURATION => :getOxygenSaturation,
            SensorType.RESPIRATION_RATE => :getRespirationRate,
            SensorType.TIME_TO_RECOVERY => :getTimeToRecovery,
            SensorType.FLOORS => :getFloors,
            SensorType.METERS_CLIMBED => :getMetersClimbed,
            SensorType.DISTANCE => :getDistance,
            SensorType.ALTITUDE => :getAltitude,
            SensorType.PRESSURE => :getPressure,
            SensorType.ACTIVE_MINUTES_DAY => :getActiveMinutesDay,
            SensorType.ACTIVE_MINUTES_WEEK => :getActiveMinutesWeek,
            SensorType.MESSAGES => :getMessages,
            SensorType.ALARM_COUNT => :getAlarmCount,
            SensorType.SOLAR_INTENSITY => :getSolarIntensity,
            SensorType.TEMPERATURE => :getTemperature,
            SensorType.IS_CONNECTED => :getIsConnected,
            SensorType.IS_DO_NOT_DISTURB => :isDoNotDisturb,
            SensorType.IS_NIGHT_MODE_ENABLED => :isNightModeEnabled,
            SensorType.IS_SLEEP_TIME => :getSleepTime,
            SensorType.MEMORY_USED => :getMemory,
            SensorType.STEPS_GOAL => :getStepGoal,
            SensorType.FLOORS_CLIMBED_GOAL => :getFloorsClimbedGoal,
            SensorType.BATTERY_GOAL => :getBatteryGoal,
            SensorType.ACTIVE_MINUTES_WEEK_GOAL => :getActiveMinutesWeekGoal
        } as Dictionary<SensorType.Enum, Symbol>;

    function getValue(sensorType as SensorType.Enum) as SersorInfoGetterValue {
        var sensorFn = SensorsDictionary.get(sensorType);

        if (sensorFn == null) {
            throw new Lang.InvalidValueException("the item sensor prop has an incorrect value");
        }

        var method = new Lang.Method(Getters, sensorFn);

        return method.invoke() as SersorInfoGetterValue;
    }

    module Getters {
        function getNone() as Null {
            return null;
        }

        function getSteps() as Number? {
            return ActivityMonitor.getInfo().steps;
        }

        function getCalories() as Number? {
            return ActivityMonitor.getInfo().calories;
        }

        function getFloors() as Number? {
            return ActivityMonitor.getInfo().floorsClimbed;
        }

        function getTimeToRecovery() as Number? {
            return ActivityMonitor.getInfo().timeToRecovery;
        }

        function getStepGoal() as Number? {
            return ActivityMonitor.getInfo().stepGoal;
        }

        function getRespirationRate() as Number? {
            return ActivityMonitor.getInfo().respirationRate;
        }

        function getMetersClimbed() as Float? {
            return ActivityMonitor.getInfo().metersClimbed;
        }

        function getFloorsClimbedGoal() as Number? {
            return ActivityMonitor.getInfo().floorsClimbedGoal;
        }

        function getDistance() as Number? {
            var distance = ActivityMonitor.getInfo().distance;

            return distance != null ? distance / 1000 : null;
        }

        function getActiveMinutesDay() as Number? {
            var value = ActivityMonitor.getInfo().activeMinutesDay;

            return value != null ? value.total : value;
        }

        function getBodyBattery() as Number? {
            var sensorInfo = SensorHistory.getBodyBatteryHistory({}).next();
            var value = sensorInfo != null ? sensorInfo.data : null;

            value = value as Number or Float or Null;

            return value != null ? value.toNumber() : value;
        }

        function getStress() as Number? {
            var sensorInfo = SensorHistory.getStressHistory({}).next();
            var value = sensorInfo != null ? sensorInfo.data : null;

            value = value as Number or Float or Null;

            return value != null ? value.toNumber() : value;
        }

        function getOxygenSaturation() as Number? {
            var activityInfo = Activity.getActivityInfo();
            var value = activityInfo != null ? activityInfo.currentOxygenSaturation : null;

            if (value == null && SensorsChecker.checkOxygenSaturationHistory()) {
                var sensorInfo = SensorHistory.getOxygenSaturationHistory({}).next();
                value = sensorInfo != null ? sensorInfo.data : null;
            }

            return value != null ? value.toNumber() : value;
        }

        function getPressure() as Number? {
            var activityInfo = Activity.getActivityInfo();
            var value = activityInfo != null ? activityInfo.ambientPressure : null;

            if (value == null && SensorsChecker.checkPressureHistory()) {
                var sensorInfo = SensorHistory.getPressureHistory({}).next();
                value = sensorInfo != null ? sensorInfo.data : null;
            }

            return value != null ? value.toNumber() : value;
        }

        function getMemory() as Number {
            return System.getSystemStats().usedMemory;
        }

        function getBattery() as Number {
            return System.getSystemStats().battery.toNumber();
        }

        function getBatteryInDays() as Number {
            return System.getSystemStats().batteryInDays.toNumber();
        }

        function getAlarmCount() as Number {
            return System.getDeviceSettings().alarmCount;
        }

        function getMessages() as Number {
            return System.getDeviceSettings().notificationCount;
        }

        function getSolarIntensity() as Number? {
            return System.getSystemStats().solarIntensity;
        }

        function isDoNotDisturb() as Boolean? {
            return System.getDeviceSettings().doNotDisturb;
        }

        function getSleepTime() as Boolean? {
            var userProfile = UserProfile.getProfile();
            var sleepTime = userProfile.sleepTime;
            var wakeTime = userProfile.wakeTime;

            if (sleepTime == null || wakeTime == null) {
                return null;
            }

            var now = Time.now();
            var midnight = Time.today();

            return isSleepTime(sleepTime, wakeTime, now, midnight);
        }

        function isSleepTime(
            sleepTime as Time.Duration,
            wakeTime as Time.Duration,
            now as Time.Moment,
            midnight as Time.Moment
        ) as Boolean {
            var oneDay = new Time.Duration(Time.Gregorian.SECONDS_PER_DAY);

            var actualWakeTime = midnight.add(wakeTime);
            var actualSleepTime = midnight.add(sleepTime);

            if (actualSleepTime.greaterThan(actualWakeTime)) {
                if (now.lessThan(actualSleepTime)) {
                    actualSleepTime = actualSleepTime.subtract(oneDay);
                } else {
                    actualWakeTime = actualWakeTime.add(oneDay);
                }
            } else if (now.greaterThan(actualSleepTime) && now.greaterThan(actualWakeTime)) {
                return false;
            }

            return now.greaterThan(actualSleepTime) && now.lessThan(actualWakeTime);
        }

        function isNightModeEnabled() as Boolean {
            return !!System.getDeviceSettings().isNightModeEnabled;
        }

        function getIsConnected() as Boolean {
            return System.getDeviceSettings().phoneConnected;
        }

        function getTemperature() as Long? {
            var sensorInfo = SensorHistory.getTemperatureHistory({}).next();
            var value = sensorInfo != null ? sensorInfo.data : null;

            return value != null ? value.toLong() : value;
        }

        function getHR() as Number? {
            var activityInfo = Activity.getActivityInfo();
            var value = activityInfo != null ? activityInfo.currentHeartRate : null;

            if (value == null && SensorsChecker.checkHeartRateHistory()) {
                var sensorInfo = SensorHistory.getHeartRateHistory({}).next();
                value = sensorInfo != null ? sensorInfo.data : value;
            }

            return value != null && value < ActivityMonitor.INVALID_HR_SAMPLE ? value.toNumber() : null;
        }

        function getAltitude() as Long? {
            var activityInfo = Activity.getActivityInfo();
            var value = activityInfo != null ? activityInfo.altitude : null;

            if (value == null && SensorsChecker.checkElevationHistory()) {
                var sensorInfo = SensorHistory.getElevationHistory({}).next();
                value = sensorInfo != null ? sensorInfo.data : value;
            }

            return value != null ? value.toLong() : value;
        }

        function getCurrentWeather() as Number? {
            var info = Weather.getCurrentConditions();

            return info != null ? info.temperature : null;
        }

        function getWeatherFeels() as Number? {
            var info = Weather.getCurrentConditions();

            return info != null ? info.feelsLikeTemperature : null;
        }

        function getCurrentForecast() as Array<Number?>? {
            var info = Weather.getDailyForecast();

            if (info == null || info.size() == 0) {
                return null;
            }

            return [info[0].lowTemperature, info[0].highTemperature] as Array<Number?>;
        }

        function getCurrentLocation() as Position.Info? {
            var positionInfo = Position.getInfo();

            if (positionInfo has :position && positionInfo.position != null) {
                return positionInfo.position as Position.Info;
            }

            return null;
        }

        function getSunrise() as Time.Moment? {
            var location = getCurrentLocation();

            if (location == null) {
                return null;
            }

            return Weather.getSunrise(location, Time.today());
        }

        function getSunset() as Time.Moment? {
            var location = getCurrentLocation();

            if (location == null) {
                return null;
            }

            return Weather.getSunset(location, Time.today());
        }

        function getBatteryGoal() as Number {
            return 100;
        }

        function getActiveMinutesWeek() as Number? {
            var value = ActivityMonitor.getInfo().activeMinutesWeek;

            return value != null ? value.total : null;
        }

        function getActiveMinutesWeekGoal() as Number? {
            return ActivityMonitor.getInfo().activeMinutesWeekGoal;
        }
    }
}
