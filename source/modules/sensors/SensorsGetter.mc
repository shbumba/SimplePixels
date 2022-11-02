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

module SensorInfoModule {
    module SensorsInfoGetter {
        var SensorsDictionary = {
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
            SensorType.IS_SLEEP_TIME => :isSleepModeEnabled,
            SensorType.IS_CHARGING => :getCharging,
            SensorType.MEMORY_USED => :getMemory,
            SensorType.IS_VIBRATE_ON => :isVibrateOn,
            SensorType.STEPS_GOAL => :getStepGoal,
            SensorType.FLOORS_CLIMBED_GOAL => :getFloorsClimbedGoal,
            SensorType.BATTERY_GOAL => :getBatteryGoal,
            SensorType.ACTIVE_MINUTES_WEEK_GOAL => :getActiveMinutesWeekGoal,
        };

        function getValue(sensorType as SensorType) as Object {            
            var sensorFn = SensorsDictionary.get(sensorType);

            if (sensorFn == null) {
                throw new Lang.InvalidValueException("the item sensor prop has an incorrect value");
            }

            var method = new Lang.Method(SensorsInfoGetter, sensorFn);

            return method.invoke();
        }

        function getNone() as Null {
            return null;
        }

        function getSteps() as Number or Null {
            return ActivityMonitor.getInfo().steps;
        }

        function getCalories() as Number or Null {
            return ActivityMonitor.getInfo().calories;
        }

        function getFloors() as Number or Null {
            return ActivityMonitor.getInfo().floorsClimbed;
        }

        function getTimeToRecovery() as Number or Null {
            return ActivityMonitor.getInfo().timeToRecovery;
        }

        function getStepGoal() as Number or Null {
            return ActivityMonitor.getInfo().stepGoal;
        }

        function getRespirationRate() as Number or Null {
            return ActivityMonitor.getInfo().respirationRate;
        }

        function getMetersClimbed() as Number or Null {
            return ActivityMonitor.getInfo().metersClimbed;
        }

        function getFloorsClimbedGoal() as Number or Null {
            return ActivityMonitor.getInfo().floorsClimbedGoal;
        }

        function getDistance() as Float or Null {
            return ActivityMonitor.getInfo().distance / 1000;
        }

        function getActiveMinutesDay() as Number or Null {
            var value = ActivityMonitor.getInfo().activeMinutesDay;

            return value != null ? value.total : value;
        }

        function getBodyBattery() as Number or Null {
            var value = SensorHistory.getBodyBatteryHistory({}).next();

            return (value != null && value.data != null) ? value.data.toNumber() : null;
        }

        function getStress() as Number or Null {
            var value = SensorHistory.getStressHistory({}).next();

            return (value != null && value.data != null) ? value.data.toNumber() : null;
        }

        function getOxygenSaturation() as Number or Null {
            var value = Activity.getActivityInfo().currentOxygenSaturation;

            if (value == null && SensorsChecker.checkOxygenSaturationHistory()) {
                value = SensorHistory.getOxygenSaturationHistory({}).next();
                value = (value != null && value.data != null) ? value.data.toNumber() : null;
            }

            return value;
        }

        function getPressure() as Number or Null {
            var value = Activity.getActivityInfo().ambientPressure;

            if (value == null && SensorsChecker.checkPressureHistory()) {
                value = SensorHistory.getPressureHistory({}).next();
                value = (value != null && value.data != null) ? value.data.toNumber() : null;
            }

            return value;
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

        function getCharging() as Boolean {
            return System.getSystemStats().charging;
        }

        function getAlarmCount() as Number {
            return System.getDeviceSettings().alarmCount;
        }

        function getMessages() as Number {
            return System.getDeviceSettings().notificationCount;
        }

        function isVibrateOn() as Boolean or Null {
            return System.getDeviceSettings().vibrateOn;
        }

        function getSolarIntensity() as Number or Null {
            return System.getSystemStats().solarIntensity;
        }

        function isDoNotDisturb() as Boolean or Null {
            return System.getDeviceSettings().doNotDisturb;
        }

        function isSleepTime() as Boolean or Null {
            var userProfile = UserProfile.getProfile();
            var sleepTime = userProfile.sleepTime;
            var wakeTime = userProfile.wakeTime;

            if (sleepTime == null || wakeTime == null) {
                return null;
            }

            var now = Time.now();
            var midnight = Time.today();

            var currentWakeTime = midnight.add(wakeTime);
            var currentSleepTime = midnight.add(sleepTime);

            return now.lessThan(currentWakeTime) || now.greaterThan(currentSleepTime);
        }

        function isNightModeEnabled() as Boolean or Null {
            return !!System.getDeviceSettings().isNightModeEnabled;
        }

        function isSleepModeEnabled() as Boolean or Null {
            var info = ActivityMonitor.getInfo();
            var value = null;

            if (info has :isSleepMode) {
                value = info.isSleepMode;
            }

            if (!value) {
                value = isSleepTime();
            }

            return !!value;
        }

        function getIsConnected() as Boolean {
            return System.getDeviceSettings().phoneConnected;
        }
        
        function getTemperature() as Number or Null {
            var value = SensorHistory.getTemperatureHistory({}).next();

            return (value != null && value.data != null) ? value.data.toLong() : null;
        }

        function getHR() as Number or Null {
            var value = Activity.getActivityInfo().currentHeartRate;

            if (value == null && SensorsChecker.checkHeartRateHistory()) {
                value = SensorHistory.getHeartRateHistory({}).next();

                if (value == null || value.data == null || value.data >= ActivityMonitor.INVALID_HR_SAMPLE) {
                    value = null;
                } else {
                    value = value.data.toNumber();
                }
            }

            return value;
        }

        function getAltitude() as Float or Null {
            var value = Activity.getActivityInfo().altitude;

            if (value == null && SensorsChecker.checkElevationHistory()) {
                value = SensorHistory.getElevationHistory({}).next();
                value = (value != null && value.data != null) ? value.data.toLong() : null;
            }

            return value;
        }

        function getCurrentWeather() as Number or Null {
            var info = Weather.getCurrentConditions();

            return (info != null) ? info.temperature : null;
        }

        function getWeatherFeels() as Number or Null {
            var info = Weather.getCurrentConditions();

            return (info != null) ? info.feelsLikeTemperature : null;
        }

        function getCurrentForecast() as Array<Number or Null> or Null { // Array<[low, high]>
            var info = Weather.getDailyForecast();

            if (info == null || info.size() == 0) {
                return null;
            }

            return [info[0].lowTemperature, info[0].highTemperature];
        }

        function getCurrentLocation() as Position.Info or Null {
            var positionInfo = Position.getInfo();

            if (positionInfo has :position && positionInfo.position != null) {
                return positionInfo.position;
            }

            return null;
        }

        function getSunrise() as Time.Moment or Null {
            var location = getCurrentLocation();

            if (location == null) {
                return null;
            }

            return Weather.getSunrise(location, Time.today());
        }

        function getSunset() as Time.Moment or Null {
            var location = getCurrentLocation();

            if (location == null) {
                return null;
            }

            return Weather.getSunset(location, Time.today());
        }

        function getBatteryGoal() as Number {
            return 100;
        }

        function getActiveMinutesWeek() as Number or Null {
            var value = ActivityMonitor.getInfo().activeMinutesWeek;

            return value != null ? value.total : null;
        }

        function getActiveMinutesWeekGoal() as Number or Null {
            return ActivityMonitor.getInfo().activeMinutesWeekGoal;
        }
    }
}
