import Toybox.Lang;
import SensorTypes;

module SensorsTexts {
    var Map = {
        SensorTypes.NONE => Rez.Strings.None,
        SensorTypes.BATTERY => Rez.Strings.Battery,
        SensorTypes.BATTERY_IN_DAYS => Rez.Strings.BatteryInDays,
        SensorTypes.CURRENT_WEATHER => Rez.Strings.Weather,
        SensorTypes.WEATHER_FEELS => Rez.Strings.WeatherFeels,
        SensorTypes.WEATHER_FORECAST => Rez.Strings.WeatherForecast,
        SensorTypes.SUNRISE => Rez.Strings.Sunrise,
        SensorTypes.SUNSET => Rez.Strings.Sunset,
        SensorTypes.STEPS => Rez.Strings.Steps,
        SensorTypes.CALORIES => Rez.Strings.Calories,
        SensorTypes.HEART_RATE => Rez.Strings.HeartRate,
        SensorTypes.STRESS => Rez.Strings.Stress,
        SensorTypes.BODY_BATTERY => Rez.Strings.BodyBattery,
        SensorTypes.OXYGEN_SATURATION => Rez.Strings.OxygenSaturation,
        SensorTypes.RESPIRATION_RATE => Rez.Strings.RespirationRate,
        SensorTypes.TIME_TO_RECOVERY => Rez.Strings.TimeToRecovery,
        SensorTypes.FLOORS => Rez.Strings.Floors,
        SensorTypes.METERS_CLIMBED => Rez.Strings.MetersClimbed,
        SensorTypes.DISTANCE => Rez.Strings.Distance,
        SensorTypes.ALTITUDE => Rez.Strings.Altitude,
        SensorTypes.PRESSURE => Rez.Strings.Pressure,
        SensorTypes.ACTIVE_MINUTES_DAY => Rez.Strings.ActiveMinutesDay,
        SensorTypes.ACTIVE_MINUTES_WEEK => Rez.Strings.ActiveMinutesWeek,
        SensorTypes.MESSAGES => Rez.Strings.Messages,
        SensorTypes.ALARM_COUNT => Rez.Strings.AlarmCount,
        SensorTypes.SOLAR_INTENSITY => Rez.Strings.SolarIntensity,
        SensorTypes.SECOND_TIME => Rez.Strings.SecondTime,
        SensorTypes.MEMORY_USED => Rez.Strings.Memory,
    };

    function getText(sensorType as SensorTypes.Enum) as Symbol? {
        return Map.get(sensorType) as Symbol?;
    }
}
