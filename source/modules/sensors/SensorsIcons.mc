import Toybox.Lang;
import SensorsGetters;
import SensorTypes;

module SensorsIcons {
    var Map = {
        SensorTypes.BATTERY => :batteryIcon,
        SensorTypes.BATTERY_IN_DAYS => :batteryIcon,
        SensorTypes.CURRENT_WEATHER => Rez.Fonts.weather_icon,
        SensorTypes.WEATHER_FEELS => Rez.Fonts.weather_icon,
        SensorTypes.WEATHER_FORECAST => Rez.Fonts.weather_icon,
        SensorTypes.SUNRISE => Rez.Fonts.sunrise_icon,
        SensorTypes.SUNSET => Rez.Fonts.sunset_icon,
        SensorTypes.STEPS => Rez.Fonts.steps_icon,
        SensorTypes.CALORIES => Rez.Fonts.calories_icon,
        SensorTypes.HEART_RATE => Rez.Fonts.heart_icon,
        SensorTypes.STRESS => Rez.Fonts.stress_icon,
        SensorTypes.BODY_BATTERY => Rez.Fonts.energy_icon,
        SensorTypes.OXYGEN_SATURATION => Rez.Fonts.oxygen_icon,
        SensorTypes.RESPIRATION_RATE => Rez.Fonts.oxygen_icon,
        SensorTypes.TIME_TO_RECOVERY => Rez.Fonts.recovery_icon,
        SensorTypes.FLOORS => Rez.Fonts.floors_icon,
        SensorTypes.METERS_CLIMBED => Rez.Fonts.floors_icon,
        SensorTypes.DISTANCE => Rez.Fonts.distance_icon,
        SensorTypes.ALTITUDE => Rez.Fonts.altitude_icon,
        SensorTypes.PRESSURE => Rez.Fonts.preasure_icon,
        SensorTypes.ACTIVE_MINUTES_DAY => Rez.Fonts.activity_icon,
        SensorTypes.ACTIVE_MINUTES_WEEK => Rez.Fonts.activity_icon,
        SensorTypes.MESSAGES => Rez.Fonts.messages_icon,
        SensorTypes.ALARM_COUNT => Rez.Fonts.alarm_icon,
        SensorTypes.SOLAR_INTENSITY => Rez.Fonts.sun_icon,
        SensorTypes.IS_CONNECTED => :isConnectedIcon,
        SensorTypes.IS_DO_NOT_DISTURB => :isDoNotDisturbIcon,
        SensorTypes.IS_NIGHT_MODE_ENABLED => :isNightModeIcon,
        SensorTypes.IS_SLEEP_TIME => :isNightModeIcon,
        SensorTypes.MEMORY_USED => Rez.Fonts.memory_icon
    };

    function getIcon(sensorType as SensorTypes.Enum, value as SersorInfoGetterValue) as Symbol? {
        var iconFn = Map.get(sensorType);

        if (iconFn instanceof Lang.Number || iconFn == null) {
            return iconFn as Symbol?;
        }

        var method = new Lang.Method(Icons, iconFn);

        return method.invoke(value) as Symbol?;
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
}
