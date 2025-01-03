import Toybox.Lang;
import Toybox.System;
import Toybox.ActivityMonitor;
import Toybox.Application.Storage;
import Toybox.Activity;
import Toybox.SensorHistory;
import Toybox.Weather;
import Toybox.UserProfile;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Position;
import Toybox.Math;
import SensorTypes;
import StoreKeys;
import SensorsCheckers.Checkers;
import TimeStackModule;
import SettingsModule.SettingType;

module SensorsGetters {
    typedef SersorInfoGetterValue as Number or Float or Boolean or Time.Moment or Position.Info or Array<Number> or Null ;
    typedef WeatherData as {
        "time" as Numeric?,
        "max" as Numeric?,
        "min" as Numeric?,
        "current" as Numeric?,
        "feels" as Numeric?,
        "icon" as Numeric?
    };

    typedef WeatherError as {
        "httpError" as Number
    };

    var Map =
        {
            SensorTypes.NONE => :getNone,
            SensorTypes.BATTERY => :getBattery,
            SensorTypes.BATTERY_IN_DAYS => :getBatteryInDays,
            SensorTypes.CURRENT_WEATHER => :getCurrentWeather,
            SensorTypes.WEATHER_FEELS => :getWeatherFeels,
            SensorTypes.WEATHER_FORECAST => :getCurrentForecast,
            SensorTypes.SUNRISE => :getSunrise,
            SensorTypes.SUNSET => :getSunset,
            SensorTypes.STEPS => :getSteps,
            SensorTypes.CALORIES => :getCalories,
            SensorTypes.HEART_RATE => :getHR,
            SensorTypes.STRESS => :getStress,
            SensorTypes.BODY_BATTERY => :getBodyBattery,
            SensorTypes.OXYGEN_SATURATION => :getOxygenSaturation,
            SensorTypes.RESPIRATION_RATE => :getRespirationRate,
            SensorTypes.TIME_TO_RECOVERY => :getTimeToRecovery,
            SensorTypes.FLOORS => :getFloors,
            SensorTypes.METERS_CLIMBED => :getMetersClimbed,
            SensorTypes.DISTANCE => :getDistanceMeters,
            SensorTypes.ALTITUDE => :getAltitude,
            SensorTypes.PRESSURE => :getPressure,
            SensorTypes.ACTIVE_MINUTES_DAY => :getActiveMinutesDay,
            SensorTypes.ACTIVE_MINUTES_WEEK => :getActiveMinutesWeek,
            SensorTypes.MESSAGES => :getMessages,
            SensorTypes.ALARM_COUNT => :getAlarmCount,
            SensorTypes.SOLAR_INTENSITY => :getSolarIntensity,
            SensorTypes.IS_CONNECTED => :getIsConnected,
            SensorTypes.IS_DO_NOT_DISTURB => :isDoNotDisturb,
            SensorTypes.IS_NIGHT_MODE_ENABLED => :isNightModeEnabled,
            SensorTypes.IS_SLEEP_TIME => :getSleepTime,
            SensorTypes.SECOND_TIME => :getSecondTime,
            SensorTypes.MEMORY_USED => :getMemory,
            SensorTypes.STEPS_GOAL => :getStepGoal,
            SensorTypes.FLOORS_CLIMBED_GOAL => :getFloorsClimbedGoal,
            SensorTypes.BATTERY_GOAL => :getBatteryGoal,
            SensorTypes.ACTIVE_MINUTES_WEEK_GOAL => :getActiveMinutesWeekGoal
        } as Dictionary<SensorTypes.Enum, Symbol>;

    const MAX_WEATHER_INTERVAL = Math.ceil(Gregorian.SECONDS_PER_HOUR * 3.2);

    function getValue(sensorType as SensorTypes.Enum) as SersorInfoGetterValue {
        var sensorFn = Map.get(sensorType);

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

        function getDistanceMeters() as Float? {
            var distanceCm = ActivityMonitor.getInfo().distance;

            return distanceCm != null ? distanceCm.toFloat() / 100 : null;
        }

        function getActiveMinutesDay() as Number? {
            var value = ActivityMonitor.getInfo().activeMinutesDay;

            return value != null ? value.total : value;
        }

        function getBodyBattery() as Number? {
            var value = null as Number or Float or Null;

            var sensorInfo = SensorHistory.getBodyBatteryHistory({}).next();
            value = sensorInfo != null ? sensorInfo.data : value;

            return value != null ? value.toNumber() : value;
        }

        function getStress() as Number? {
            var value = null as Number or Float or Null;

            var sensorInfo = SensorHistory.getStressHistory({}).next();
            value = sensorInfo != null ? sensorInfo.data : value;

            return value != null ? value.toNumber() : value;
        }

        function getOxygenSaturation() as Number? {
            var activityInfo = Activity.getActivityInfo();
            var value = activityInfo != null ? activityInfo.currentOxygenSaturation : null;

            if (value == null && Checkers.checkOxygenSaturationHistory()) {
                try {
                    var history = SensorHistory.getOxygenSaturationHistory({}) as SensorHistory.SensorHistoryIterator?;
                    var sensorInfo = history != null ? history.next() : null;
                    value = sensorInfo != null ? sensorInfo.data : null;
                } catch (e) {
                    //
                }
            }

            return value != null ? value.toNumber() : value;
        }

        function getPressure() as Number? {
            var activityInfo = Activity.getActivityInfo();
            var value = activityInfo != null ? activityInfo.ambientPressure : null;

            if (value == null && Checkers.checkPressureHistory()) {
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

        function getSecondTime() as Gregorian.Info {
            return TimeStackModule.secondTime();
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

        function getHR() as Number? {
            var activityInfo = Activity.getActivityInfo();
            var value = activityInfo != null ? activityInfo.currentHeartRate : null;

            if (value == null && Checkers.checkHeartRateHistory()) {
                var sensorInfo = SensorHistory.getHeartRateHistory({}).next();
                value = sensorInfo != null ? sensorInfo.data : value;
            }

            return value != null && value < ActivityMonitor.INVALID_HR_SAMPLE ? value.toNumber() : null;
        }

        function getAltitude() as Long? {
            var activityInfo = Activity.getActivityInfo();
            var value = activityInfo != null ? activityInfo.altitude : null;

            if (value == null && Checkers.checkElevationHistory()) {
                var sensorInfo = SensorHistory.getElevationHistory({}).next();
                value = sensorInfo != null ? sensorInfo.data : value;
            }

            return value != null ? value.toLong() : value;
        }

        function _getOWWeatherData() as Dictionary? {
            var data = Storage.getValue(StoreKeys.OPENWEATHER_DATA) as WeatherData or WeatherError or Null;

            if (data == null || data.hasKey("httpError")) {
                return null;
            }

            var weatherTime = new Time.Moment(data["time"] as Number);
            var currentTime = Time.now();

            if (currentTime.compare(weatherTime) > MAX_WEATHER_INTERVAL) {
                return null;
            }

            return data as Dictionary;
        }

        function _getCurrentOWWeather() as Array<Number?>? {
            var info = _getOWWeatherData();
            if (info == null) {
                return null;
            }
            return [info["current"], info["icon"]] as Array<Number?>;
        }

        function _getWeatherOWFeels() as Number? {
            var info = _getOWWeatherData();

            return info != null ? info["feels"] : null;
        }

        function _getCurrentOWForecast() as Array<Number?>? {
            var info = _getOWWeatherData();

            if (info == null) {
                return null;
            }

            return [info["max"], info["min"]] as Array<Number?>;
        }

        function _getCurrentGarminWeather() as Array<Number?>? {
            var info = Weather.getCurrentConditions();
            if (info == null) {
                return null;
            }
            return [info.temperature, info.condition] as Array<Number?>;
        }

        function _getWeatherGarminFeels() as Number? {
            var info = Weather.getCurrentConditions();

            return info != null ? info.feelsLikeTemperature : null;
        }

        function _getCurrentGarminForecast() as Array<Number?>? {
            var info = Weather.getDailyForecast();

            if (info == null || info.size() == 0) {
                return null;
            }

            return [info[0].lowTemperature, info[0].highTemperature] as Array<Number?>;
        }

        function getCurrentWeather() as Array<Number?>? {
            var isOWEnabled = !!SettingsModule.getValue(SettingType.OPENWEATHER_ENABLED);

            return isOWEnabled ? _getCurrentOWWeather() : _getCurrentGarminWeather();
        }

        function getWeatherFeels() as Number? {
            var isOWEnabled = !!SettingsModule.getValue(SettingType.OPENWEATHER_ENABLED);

            return isOWEnabled ? _getWeatherOWFeels() : _getWeatherGarminFeels();
        }

        function getCurrentForecast() as Array<Number?>? {
            var isOWEnabled = !!SettingsModule.getValue(SettingType.OPENWEATHER_ENABLED);

            return isOWEnabled ? _getCurrentOWForecast() : _getCurrentGarminForecast();
        }

        function getCurrentLocation() as Position.Location? {
            var positionInfo = Position.getInfo();

            if (positionInfo has :position && positionInfo.position != null) {
                return positionInfo.position as Position.Location;
            }

            return null;
        }

        function _getSunPhaseTime(action) as Time.Moment? {
            var location = getCurrentLocation();

            if (location == null) {
                return null;
            }

            var method = new Lang.Method(Weather, action);

            return method.invoke(location, Time.today());
        }

        function getSunrise() as Gregorian.Info? {
            var time = _getSunPhaseTime(:getSunrise);

            if (time == null) {
                return null;
            }

            return Gregorian.info(time, Time.FORMAT_SHORT);
        }

        function getSunset() as Gregorian.Info? {
            var time = _getSunPhaseTime(:getSunset);

            if (time == null) {
                return null;
            }

            return Gregorian.info(time, Time.FORMAT_SHORT);
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
