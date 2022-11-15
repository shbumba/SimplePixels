import Toybox.Lang;
import Toybox.System;
import Toybox.ActivityMonitor;
import Toybox.Activity;
import Toybox.SensorHistory;
import SensorTypes;

module SensorsCheckers {
    var Map = {
        SensorTypes.NONE => true,
        SensorTypes.STEPS => true,
        SensorTypes.CALORIES => true,
        SensorTypes.BATTERY => true,
        SensorTypes.BATTERY_IN_DAYS => :checkBatteryInDays,
        SensorTypes.SOLAR_INTENSITY => :checkSolarIntensivity,
        SensorTypes.IS_CONNECTED => true,
        SensorTypes.HEART_RATE => true,
        SensorTypes.FLOORS => :checkFloors,
        SensorTypes.ALTITUDE => true,
        SensorTypes.MESSAGES => true,
        SensorTypes.ALARM_COUNT => true,
        SensorTypes.MEMORY_USED => true,
        SensorTypes.CURRENT_WEATHER => true,
        SensorTypes.WEATHER_FEELS => true,
        SensorTypes.WEATHER_FORECAST => true,
        SensorTypes.SUNRISE => true,
        SensorTypes.SUNSET => true,
        SensorTypes.OXYGEN_SATURATION => :checkOxygenSaturation,
        SensorTypes.PRESSURE => :checkPressure,
        SensorTypes.TIME_TO_RECOVERY => :checkTimeToRecovery,
        SensorTypes.STEPS_GOAL => true,
        SensorTypes.RESPIRATION_RATE => :checkRespirationRate,
        SensorTypes.METERS_CLIMBED => :checkMetersClimbed,
        SensorTypes.IS_DO_NOT_DISTURB => :checkDoNotDisturb,
        SensorTypes.IS_NIGHT_MODE_ENABLED => :checkIsNightMode,
        SensorTypes.IS_SLEEP_TIME => true,
        SensorTypes.FLOORS_CLIMBED_GOAL => :checkFloorsClimbedGoal,
        SensorTypes.DISTANCE => true,
        SensorTypes.ACTIVE_MINUTES_DAY => true,
        SensorTypes.BODY_BATTERY => :checkBodyBattery,
        SensorTypes.STRESS => :checkStress,
        SensorTypes.BATTERY_GOAL => true,
        SensorTypes.ACTIVE_MINUTES_WEEK => true,
        SensorTypes.ACTIVE_MINUTES_WEEK_GOAL => true
    };

    function check(sensorType as SensorTypes.Enum) as Boolean {
        var sensorCkecker = Map.get(sensorType);

        if (sensorCkecker == null) {
            throw new Toybox.Lang.InvalidValueException("the item sensor prop has an incorrect value");
        } else if (sensorCkecker instanceof Lang.Boolean) {
            return sensorCkecker;
        }

        var method = new Lang.Method(Checkers, sensorCkecker);

        return method.invoke() as Boolean;
    }

    module Checkers {
        function checkFloors() as Boolean {
            return ActivityMonitor.getInfo() has :floorsClimbed;
        }

        function checkTimeToRecovery() as Boolean {
            return ActivityMonitor.getInfo() has :timeToRecovery;
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

        function checkOxygenSaturation() as Boolean {
            return Activity.getActivityInfo() has :currentOxygenSaturation;
        }

        function checkPressure() as Boolean {
            return Activity.getActivityInfo() has :ambientPressure;
        }

        function checkSolarIntensivity() as Boolean {
            return System.getSystemStats() has :solarIntensity;
        }

        function checkBatteryInDays() as Boolean {
            return System.getSystemStats() has :batteryInDays;
        }

        function checkDoNotDisturb() as Boolean {
            return System.getDeviceSettings() has :doNotDisturb;
        }

        function checkIsNightMode() as Boolean {
            return System.getDeviceSettings() has :isNightModeEnabled;
        }

        function checkSensorHistory() as Boolean {
            return Toybox has :SensorHistory;
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

        function checkHeartRateHistory() as Boolean {
            return checkSensorHistory() && SensorHistory has :getHeartRateHistory;
        }

        function checkElevationHistory() as Boolean {
            return checkSensorHistory() && SensorHistory has :getElevationHistory;
        }
    }
}
