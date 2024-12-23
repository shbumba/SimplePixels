import Toybox.Lang;
import SensorsGetters;
import SensorTypes;

module SensorsIcons {
    var Map =
        ({
            SensorTypes.BATTERY => :batteryIcon,
            SensorTypes.BATTERY_IN_DAYS => :batteryIcon,
            SensorTypes.CURRENT_WEATHER => :weatherIcon,
            SensorTypes.WEATHER_FEELS => Rez.Fonts.weather_icon,
            SensorTypes.WEATHER_FORECAST => Rez.Fonts.weather_icon,
            SensorTypes.SUNRISE => Rez.Fonts.sunrise_icon,
            SensorTypes.SUNSET => Rez.Fonts.sunset_icon,
            SensorTypes.SUN_RISE_SET => :sunRiseOrSetIcon,
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
            SensorTypes.SECOND_TIME => Rez.Fonts.alarm_icon,
            SensorTypes.MEMORY_USED => Rez.Fonts.memory_icon
        }) as Dictionary<SensorTypes.Enum, Symbol or ResourceId>;

    var WeatherIconsMap =
        ({
            //Garmin weather icons
            0 => Rez.Fonts.sun_icon, //Clean
            1 => Rez.Fonts.clouds_icon, //Partly cloudy -> Cloudy
            2 => Rez.Fonts.clouds_icon, //Mostly cloudy -> Cloudy
            3 => Rez.Fonts.rain_icon, //Rain
            4 => Rez.Fonts.snow_icon, //Snow
            5 => Rez.Fonts.sun_icon, //Windy -> Clean
            6 => Rez.Fonts.thunderstorm_icon, //Thunderstorms
            7 => Rez.Fonts.rain_icon, //Wintry mix -> Rain
            8 => Rez.Fonts.fog_icon, //Fog
            9 => Rez.Fonts.fog_icon, //Hazy -> Fog
            10 => Rez.Fonts.hail_icon, //Hail
            11 => Rez.Fonts.rain_icon, //Scattered showers -> Rain
            12 => Rez.Fonts.thunderstorm_icon, //Scattered thunderstorms -> Thunderstorms
            13 => Rez.Fonts.rain_icon, //Unknown precipitation -> Rain
            14 => Rez.Fonts.rain_icon, //Light rain -> Rain
            15 => Rez.Fonts.rain_icon, //Heavy rain -> Rain
            16 => Rez.Fonts.snow_icon, //Light snow -> Snow
            17 => Rez.Fonts.snow_icon, //Heavy snow -> Snow
            18 => Rez.Fonts.snow_icon, //Light rain snow -> Snow
            19 => Rez.Fonts.snow_icon, //Heavy rain snow -> Snow
            20 => Rez.Fonts.clouds_icon, //Cloudy
            21 => Rez.Fonts.snow_icon, //Rain snow -> Snow
            22 => Rez.Fonts.sun_icon, //Partly clear -> Clean
            23 => Rez.Fonts.sun_icon, //Mostly clear -> Clean
            24 => Rez.Fonts.rain_icon, //Light showers -> Rain
            25 => Rez.Fonts.rain_icon, //Showers -> Rain
            26 => Rez.Fonts.rain_icon, //Heavy showers -> Rain
            27 => Rez.Fonts.rain_icon, //Chance of showers -> Rain
            28 => Rez.Fonts.thunderstorm_icon, //Chance of thunderstorms -> Thunderstorms
            29 => Rez.Fonts.fog_icon, //Mist -> Fog
            30 => Rez.Fonts.fog_icon, //Dust -> Fog
            31 => Rez.Fonts.rain_icon, //Drizzle -> Rain
            32 => Rez.Fonts.hurricane_icon, //Tornado -> Hurricane
            33 => Rez.Fonts.fog_icon, //Smoke -> Fog
            34 => Rez.Fonts.snow_icon, //Ice -> Snow
            35 => Rez.Fonts.fog_icon, //Sand -> Fog
            36 => Rez.Fonts.hurricane_icon, //Squall -> Hurricane
            37 => Rez.Fonts.fog_icon, //Sandstorm -> Fog
            38 => Rez.Fonts.fog_icon, //Volcanic ash -> Fog
            39 => Rez.Fonts.fog_icon, //Haze -> Fog
            40 => Rez.Fonts.sun_icon, //Fair -> Clean
            41 => Rez.Fonts.hurricane_icon, //Hurricane
            42 => Rez.Fonts.hurricane_icon, //Tropical storm -> Hurricane
            43 => Rez.Fonts.clouds_icon, //Chance of snow -> Cloudy
            44 => Rez.Fonts.clouds_icon, //Chance of rain snow -> Cloudy
            45 => Rez.Fonts.clouds_icon, //Cloudy chance of rain -> Cloudy
            46 => Rez.Fonts.clouds_icon, //Cloudy chance of snow -> Cloudy
            47 => Rez.Fonts.clouds_icon, //Cloudy chance of rain snow -> Cloudy
            48 => Rez.Fonts.snow_icon, //Flurries -> Snow
            49 => Rez.Fonts.rain_icon, //Freezing rain -> Rain
            50 => Rez.Fonts.rain_icon, //Sleet -> Rain
            51 => Rez.Fonts.snow_icon, //Ice snow -> Snow
            52 => Rez.Fonts.clouds_icon, //Thin clouds -> Cloudy
            53 => Rez.Fonts.sun_icon, //Unknown -> Clean

            //Open weather icons
            200 => Rez.Fonts.thunderstorm_icon, //thunderstorm with light rain
            201 => Rez.Fonts.thunderstorm_icon, //thunderstorm with rain
            202 => Rez.Fonts.thunderstorm_icon, //thunderstorm with heavy rain
            210 => Rez.Fonts.thunderstorm_icon, //light thunderstorm
            211 => Rez.Fonts.thunderstorm_icon, //thunderstorm
            212 => Rez.Fonts.thunderstorm_icon, //heavy thunderstorm
            221 => Rez.Fonts.thunderstorm_icon, //ragged thunderstorm
            230 => Rez.Fonts.thunderstorm_icon, //thunderstorm with light drizzle
            231 => Rez.Fonts.thunderstorm_icon, //thunderstorm with drizzle
            232 => Rez.Fonts.thunderstorm_icon, //thunderstorm with heavy drizzle
            300 => Rez.Fonts.rain_icon, //light intensity drizzle
            301 => Rez.Fonts.rain_icon, //drizzle
            302 => Rez.Fonts.rain_icon, //heavy intensity drizzle
            310 => Rez.Fonts.rain_icon, //light intensity drizzle rain
            311 => Rez.Fonts.rain_icon, //drizzle rain
            312 => Rez.Fonts.rain_icon, //heavy intensity drizzle rain
            313 => Rez.Fonts.rain_icon, //Cleanshower rain and drizzle
            314 => Rez.Fonts.rain_icon, //heavy shower rain and drizzle
            321 => Rez.Fonts.rain_icon, //shower drizzle
            500 => Rez.Fonts.rain_icon, //light rain
            501 => Rez.Fonts.rain_icon, //moderate rain
            502 => Rez.Fonts.rain_icon, //heavy intensity rain
            503 => Rez.Fonts.rain_icon, //very heavy rain
            504 => Rez.Fonts.rain_icon, //extreme rain
            511 => Rez.Fonts.rain_icon, //freezing rain
            520 => Rez.Fonts.rain_icon, //light intensity shower rain
            521 => Rez.Fonts.rain_icon, //shower rain
            522 => Rez.Fonts.rain_icon, //heavy intensity shower rain
            531 => Rez.Fonts.rain_icon, //ragged shower rain
            600 => Rez.Fonts.snow_icon, //light snow
            601 => Rez.Fonts.snow_icon, //snow
            602 => Rez.Fonts.snow_icon, //heavy snow
            611 => Rez.Fonts.snow_icon, //sleet
            612 => Rez.Fonts.snow_icon, //light shower sleet
            613 => Rez.Fonts.snow_icon, //shower sleet
            615 => Rez.Fonts.snow_icon, //light rain and snow
            616 => Rez.Fonts.snow_icon, //rain and snow
            620 => Rez.Fonts.snow_icon, //light shower snow
            621 => Rez.Fonts.snow_icon, //shower snow
            622 => Rez.Fonts.snow_icon, //heavy shower snow
            701 => Rez.Fonts.fog_icon, //mist
            711 => Rez.Fonts.fog_icon, //smoke
            721 => Rez.Fonts.fog_icon, //haze
            731 => Rez.Fonts.fog_icon, //sand/dust whirls
            741 => Rez.Fonts.fog_icon, //fog
            751 => Rez.Fonts.fog_icon, //sand
            761 => Rez.Fonts.fog_icon, //dust
            762 => Rez.Fonts.fog_icon, //volcanic ash
            771 => Rez.Fonts.hurricane_icon, //squalls
            781 => Rez.Fonts.hurricane_icon, //tornado
            800 => Rez.Fonts.sun_icon, //Clean
            801 => Rez.Fonts.clouds_icon, //few clouds: 11-25%
            802 => Rez.Fonts.clouds_icon, //scattered clouds: 25-50%
            803 => Rez.Fonts.clouds_icon, //broken clouds: 51-84%
            804 => Rez.Fonts.clouds_icon //overcast clouds: 85-100%
        }) as Dictionary<Number, Symbol or ResourceId>;

    function getIcon(sensorType as SensorTypes.Enum, value as SersorInfoGetterValue) as ResourceId? {
        var iconFn = Map.get(sensorType);

        if (iconFn instanceof Lang.ResourceId || iconFn == null) {
            return iconFn as ResourceId?;
        }

        var method = new Lang.Method(Icons, iconFn);

        return method.invoke(value) as ResourceId?;
    }

    module Icons {
        function batteryIcon(value as SersorInfoGetterValue) as ResourceId {
            if (value == null || value == true || value >= 80) {
                return Rez.Fonts.battery_100_icon; // 100%
            } else if (value >= 60) {
                return Rez.Fonts.battery_75_icon; // 75%
            } else if (value >= 35) {
                return Rez.Fonts.battery_50_icon; // 50%
            } else if (value > 10) {
                return Rez.Fonts.battery_25_icon; // 25%
            }

            return Rez.Fonts.battery_0_icon; // 0%
        }

        function isConnectedIcon(value as SersorInfoGetterValue) as ResourceId? {
            return value == true ? Rez.Fonts.connection_icon : null;
        }

        function isNightModeIcon(value as SersorInfoGetterValue) as ResourceId? {
            return value == true ? Rez.Fonts.sleep_icon : null;
        }

        function isDoNotDisturbIcon(value as SersorInfoGetterValue) as ResourceId? {
            return value == true ? Rez.Fonts.dnd_icon : null;
        }

        function weatherIcon(value as SersorInfoGetterValue) as ResourceId? {
            if (value == null || value == true) {
                return Rez.Fonts.weather_icon;
            } else {
                return value[1] == null ? Rez.Fonts.weather_icon : WeatherIconsMap.get(value[1]);
            }
        }
        function sunRiseOrSetIcon(value as SersorInfoGetterValue) as ResourceId? {
            if (value == null || value == true || value[0] == null) {
                return Rez.Fonts.sunrise_or_set_icon;
            } else {
                return value[0] == 0
                    ? Rez.Fonts.sunrise_icon
                    : Rez.Fonts.sunset_icon;
            }
        }
    }
}
