import Toybox.Lang;
import Toybox.System;

module SensorInfoModule {
    module SensorType {
        enum {
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
            IS_CONNECTED = 23,
            IS_DO_NOT_DISTURB = 24,
            IS_NIGHT_MODE_ENABLED = 25,
            IS_SLEEP_TIME = 26,
            IS_CHARGING = 27,
            MEMORY_USED = 100,
            IS_VIBRATE_ON = 101,
            STEPS_GOAL = 102,
            FLOORS_CLIMBED_GOAL = 103,
            BATTERY_GOAL = 104,
            ACTIVE_MINUTES_WEEK_GOAL = 105,
        }
    }

    class SensorsInfoService {
        private var awailableSensors as Array<SensorType> = [];

        function initialize() {
            self.awailableSensors = self.checkAwailableSensors();
            self.cleanChecker();
        }

        private function cleanChecker() as Void {
            SensorsChecker.SensorsDictionary = {};
        }

        private function checkAwailableSensors() as Array<SensorType> {
            var keys = SensorsInfoGetter.SensorsDictionary.keys();
            var awailableSensors as Array<SensorType> = [];

            for (var i = 0; i < keys.size(); i++) {
                var key = keys[i];
                var isAwailable = SensorsChecker.check(key);

                if (isAwailable) {
                    awailableSensors.add(key);
                }
            }

            return awailableSensors;
        }

        public function isAwailable(sensorType as SensorType) as Boolean {
            return self.awailableSensors.indexOf(sensorType) > -1;
        }
        
        public function getValue(sensorType as SensorType) as Object {
            if (!self.isAwailable(sensorType)) {
                return null;
            }

            return SensorsInfoGetter.getValue(sensorType);
        }

        public function transformValue(sensorType as SensorType) as String {
            return SensorsDisplay.transformValue(sensorType, self.getValue(sensorType));
        }

        public function getText(sensorType as SensorType) as String {
            return SensorsDisplay.getText(sensorType);
        }

        public function getIcon(sensorType as SensorType) as String {
            return SensorsDisplay.getIcon(sensorType, self.getValue(sensorType));
        }
    }
}
