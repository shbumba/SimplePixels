import Toybox.Lang;
import Toybox.System;
import Toybox.ActivityMonitor;
import Toybox.Activity;
import Toybox.SensorHistory;
import SensorInfoModule.SensorType;

module SensorsChecker {
    var SensorsDictionary = {
        SensorType.NONE => true,
        SensorType.STEPS => true,
        SensorType.CALORIES => true,
        SensorType.BATTERY => true,
        SensorType.BATTERY_IN_DAYS => :checkBatteryInDays,
        SensorType.SOLAR_INTENSITY => :checkSolarIntensivity,
        SensorType.IS_CONNECTED => true,
        SensorType.HEART_RATE => true,
        SensorType.FLOORS => :checkFloors,
        SensorType.ALTITUDE => true,
        SensorType.MESSAGES => true,
        SensorType.ALARM_COUNT => true,
        SensorType.MEMORY_USED => true,
        SensorType.CURRENT_WEATHER => true,
        SensorType.WEATHER_FEELS => true,
        SensorType.WEATHER_FORECAST => true,
        SensorType.SUNRISE => true,
        SensorType.SUNSET => true,
        SensorType.OXYGEN_SATURATION => :checkOxygenSaturation,
        SensorType.PRESSURE => :checkPressure,
        SensorType.TIME_TO_RECOVERY => :checkTimeToRecovery,
        SensorType.STEPS_GOAL => true,
        SensorType.RESPIRATION_RATE => :checkRespirationRate,
        SensorType.METERS_CLIMBED => :checkMetersClimbed,
        SensorType.IS_DO_NOT_DISTURB => :checkDoNotDisturb,
        SensorType.IS_NIGHT_MODE_ENABLED => :checkIsNightMode,
        SensorType.IS_SLEEP_TIME => true,
        SensorType.FLOORS_CLIMBED_GOAL => :checkFloorsClimbedGoal,
        SensorType.DISTANCE => true,
        SensorType.ACTIVE_MINUTES_DAY => true,
        SensorType.BODY_BATTERY => :checkBodyBattery,
        SensorType.STRESS => :checkStress,
        SensorType.BATTERY_GOAL => true,
        SensorType.ACTIVE_MINUTES_WEEK => true,
        SensorType.ACTIVE_MINUTES_WEEK_GOAL => true
    };

    function check(sensorType as SensorType.Enum) as Boolean {
        var sensorCkecker = SensorsDictionary.get(sensorType);

        if (sensorCkecker == null) {
            throw new Toybox.Lang.InvalidValueException("the item sensor prop has an incorrect value");
        } else if (sensorCkecker instanceof Lang.Boolean) {
            return sensorCkecker;
        }

        var method = new Lang.Method(SensorsChecker, sensorCkecker);

        return method.invoke() as Boolean;
    }

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
