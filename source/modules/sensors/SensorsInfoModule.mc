import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

module SensorInfoModule {
    module SensorType {
        enum Enum {
            NONE = 0,
            BATTERY = 1,
            BATTERY_IN_DAYS = 2,
            CURRENT_WEATHER = 3,
            STEPS = 4,
            CALORIES = 5,
            HEART_RATE = 6,
            STRESS = 7,
            BODY_BATTERY = 8,
            OXYGEN_SATURATION = 9,
            RESPIRATION_RATE = 10,
            TIME_TO_RECOVERY = 11,
            FLOORS = 12,
            METERS_CLIMBED = 13,
            DISTANCE = 14,
            ALTITUDE = 15,
            PRESSURE = 16,
            ACTIVE_MINUTES_DAY = 17,
            ACTIVE_MINUTES_WEEK = 18,
            MESSAGES = 19,
            ALARM_COUNT = 20,
            SOLAR_INTENSITY = 21,
            TEMPERATURE = 22,
            WEATHER_FEELS = 23,
            WEATHER_FORECAST = 24,
            SUNRISE = 25,
            SUNSET = 26,
            IS_CONNECTED = 100,
            IS_DO_NOT_DISTURB = 101,
            IS_NIGHT_MODE_ENABLED = 102,
            IS_SLEEP_TIME = 103,
            IS_CHARGING = 104,
            MEMORY_USED = 500,
            IS_VIBRATE_ON = 501,
            STEPS_GOAL = 502,
            FLOORS_CLIMBED_GOAL = 503,
            BATTERY_GOAL = 504,
            ACTIVE_MINUTES_WEEK_GOAL = 505,
        }
    }

    class SensorsInfoService {
        private var awailableSensors as Array<SensorType.Enum> = [] as Array<SensorType.Enum>;

        function initialize() {
            self.awailableSensors = self.checkAwailableSensors();
            self.cleanChecker();
        }

        private function cleanChecker() as Void {
            SensorsChecker.SensorsDictionary = {} as Dictionary<SensorType.Enum, Symbol>;
        }

        private function checkAwailableSensors() as Array<SensorType.Enum> {
            var keys = SensorsInfoGetter.SensorsDictionary.keys();
            var awailableSensors = [] as Array<SensorType.Enum>;

            for (var i = 0; i < keys.size(); i++) {
                var key = keys[i] as SensorType.Enum;
                var isAwailable = SensorsChecker.check(key);

                if (isAwailable) {
                    awailableSensors.add(key);
                }
            }

            return awailableSensors;
        }

        public function isAwailable(sensorType as SensorType.Enum) as Boolean {
            return self.awailableSensors.indexOf(sensorType) > -1;
        }
        
        public function getValue(sensorType as SensorType.Enum) as SersorInfoGetterValue {
            if (!self.isAwailable(sensorType)) {
                return null;
            }

            return SensorsInfoGetter.getValue(sensorType);
        }

        public function transformValue(sensorType as SensorType.Enum) as String {
            return SensorsDisplay.transformValue(sensorType, self.getValue(sensorType));
        }

        public function getIcon(sensorType as SensorType.Enum) as FontResource or Null {
            var iconSymbol = SensorsDisplay.getIcon(sensorType, self.getValue(sensorType));

            return iconSymbol != null ? ResourcesCache.get(iconSymbol) as FontResource : null;
        }
    }
}
