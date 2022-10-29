import Toybox.Lang;
import Toybox.System;
import Toybox.ActivityMonitor;
import Toybox.Activity;
import Toybox.SensorHistory;
import Toybox.Weather;

module SensorInfoModule {
    module SensorsChecker {
        var SensorsDictionary = {
            SensorType.NONE => :checkIsAlwaysTrue,
            SensorType.STEPS => :checkSteps,
            SensorType.CALORIES => :checkCalories,
            SensorType.TEMPERATURE => :checkTemperature,
            SensorType.BATTERY => :checkBattery,
            SensorType.BATTERY_IN_DAYS => :checkBatteryInDays,
            SensorType.IS_CHARGING => :checkCharging,
            SensorType.SOLAR_INTENSITY => :checkSolarIntensivity,
            SensorType.IS_CONNECTED => :checkIsConnected,
            SensorType.HEART_RATE => :checkHR,
            SensorType.FLOORS => :checkFloors,
            SensorType.ALTITUDE => :checkAltitude,
            SensorType.MESSAGES => :checkMessages,
            SensorType.ALARM_COUNT => :checkAlarmCount,
            SensorType.IS_VIBRATE_ON => :checkVibrateOn,
            SensorType.MEMORY_USED => :checkMemory,
            SensorType.CURRENT_WEATHER => :checkCurrentWeather,
            SensorType.OXYGEN_SATURATION => :checkOxygenSaturation,
            SensorType.PRESSURE => :checkPressure,
            SensorType.TIME_TO_RECOVERY => :checkTimeToRecovery,
            SensorType.STEPS_GOAL => :checkStepGoal,
            SensorType.RESPIRATION_RATE => :checkRespirationRate,
            SensorType.METERS_CLIMBED => :checkMetersClimbed,
            SensorType.IS_DO_NOT_DISTURB => :checkDoNotDisturb,
            SensorType.IS_NIGHT_MODE_ENABLED => :checkIsNightMode,
            SensorType.IS_SLEEP_TIME => :checkIsAlwaysTrue,
            SensorType.FLOORS_CLIMBED_GOAL => :checkFloorsClimbedGoal,
            SensorType.DISTANCE => :checkDistance,
            SensorType.ACTIVE_MINUTES_DAY => :checkActiveMinutesDay,
            SensorType.BODY_BATTERY => :checkBodyBattery,
            SensorType.STRESS => :checkStress,
            SensorType.BATTERY_GOAL => :checkIsAlwaysTrue,
            SensorType.ACTIVE_MINUTES_WEEK => :checkActiveMinutesWeek,
            SensorType.ACTIVE_MINUTES_WEEK_GOAL => :checkActiveMinutesWeekGoal,
        };
        
        function check(sensorType as SensorType) as Boolean {
            var sensorFn = SensorsDictionary.get(sensorType);

            if (sensorFn == null) {
                throw new Toybox.Lang.InvalidValueException("the item sensor prop has an incorrect value");
            }

            var method = new Lang.Method(SensorsChecker, sensorFn);

            return method.invoke();
        }

        function checkSteps() as Boolean {
            return ActivityMonitor.getInfo() has :steps;
        }

        function checkCalories() as Boolean {
            return ActivityMonitor.getInfo() has :calories;
        }

        function checkFloors() as Boolean {
            return ActivityMonitor.getInfo() has :floorsClimbed;
        }

        function checkTimeToRecovery() as Boolean {
            return ActivityMonitor.getInfo() has :timeToRecovery;
        }

        function checkStepGoal() as Boolean {
            return ActivityMonitor.getInfo() has :stepGoal;
        }

        function checkRespirationRate() as Boolean {
            return ActivityMonitor.getInfo() has :respirationRate;
        }

        function checkMetersClimbed() as Boolean {
            return ActivityMonitor.getInfo() has :metersClimbed;
        }

        function checkFloorsClimbedGoal() as Boolean {
            return ActivityMonitor.getInfo() has :floorsClimbedGoal;
        }

        function checkDistance() as Boolean {
            return ActivityMonitor.getInfo() has :distance;
        }

        function checkActiveMinutesDay() as Boolean {
            return ActivityMonitor.getInfo() has :activeMinutesDay;
        }

        function checkActiveMinutesWeek() as Boolean {
            return ActivityMonitor.getInfo() has :activeMinutesWeek;
        }

        function checkActiveMinutesWeekGoal() as Boolean {
            return ActivityMonitor.getInfo() has :activeMinutesWeekGoal;
        }

        function checkOxygenSaturation() as Boolean {
            return Activity.getActivityInfo() has :currentOxygenSaturation;
        }

        function checkPressure() as Boolean {
            return Activity.getActivityInfo() has :ambientPressure;
        }

        function checkHR() as Boolean {
            return Activity.getActivityInfo() has :currentHeartRate;
        }

        function checkAltitude() as Boolean {
            return Activity.getActivityInfo() has :altitude;
        }

        function checkBodyBattery() as Boolean {
            return checkSensorHistory() && SensorHistory has :getBodyBatteryHistory;
        }

        function checkStress() as Boolean {
            return checkSensorHistory() && SensorHistory has :getStressHistory;
        }

        function checkOxygenSaturationHistory() as Boolean {
            return checkSensorHistory() && SensorHistory has :getOxygenSaturationHistory;
        }

        function checkPressureHistory() as Boolean {
            return checkSensorHistory() && SensorHistory has :getPressureHistory;
        }

        function checkMemory() as Boolean {
            return System.getSystemStats() has :usedMemory;
        }
        
        function checkSolarIntensivity() as Boolean {
            return System.getSystemStats() has :solarIntensity;
        }

        function checkBattery() as Boolean {
            return System.getSystemStats() has :battery;
        }

        function checkBatteryInDays() as Boolean {
            return System.getSystemStats() has :batteryInDays;
        }

        function checkCharging() as Boolean {
            return System.getSystemStats() has :charging;
        }

        function checkAlarmCount() as Boolean {
            return System.getDeviceSettings() has :alarmCount;
        }

        function checkMessages() as Boolean {
            return System.getDeviceSettings() has :notificationCount;
        }

        function checkVibrateOn() as Boolean {
            return System.getDeviceSettings() has :vibrateOn;
        }

        function checkDoNotDisturb() as Boolean {
            return System.getDeviceSettings() has :doNotDisturb;
        }

        function checkIsConnected() as Boolean {
            return System.getDeviceSettings() has :phoneConnected;
        }

        function checkCurrentWeather() as Boolean {
            return Weather has :getCurrentConditions;
        }

        function checkSensorHistory() as Boolean {
            return Toybox has :SensorHistory;
        }

        function checkTemperature() as Boolean {
            return checkSensorHistory() && SensorHistory has :getTemperatureHistory;
        }

        function checkHeartRateHistory() as Boolean {
            return checkSensorHistory() && SensorHistory has :getHeartRateHistory;
        }

        function checkElevationHistory() as Boolean {
            return checkSensorHistory() && SensorHistory has :getElevationHistory;
        }
        
        function checkIsNightMode() as Boolean {
            return System.getDeviceSettings() has :isNightModeEnabled;
        }

        function checkIsAlwaysTrue() as Boolean {
            return true;
        }
    }
}
