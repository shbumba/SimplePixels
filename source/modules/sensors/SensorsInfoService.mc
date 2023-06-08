import Toybox.Lang;
import Toybox.System;
import SensorsIcons;
import SensorsTransformators;
import SensorsGetters;
import SensorsCheckers;
import ResourcesCache;

class SensorsInfoService {
    private var awailableSensors as Array<SensorTypes.Enum> = [];

    function initialize() {
        self.awailableSensors = self.checkAwailableSensors();
        self.cleanChecker();
    }

    private function cleanChecker() as Void {
        SensorsCheckers.Map = {};
    }

    private function checkAwailableSensors() as Array<SensorTypes.Enum> {
        var keys = SensorsGetters.Map.keys() as Array<SensorTypes.Enum>;
        var awailableSensors = [] as Array<SensorTypes.Enum>;

        for (var i = 0; i < keys.size(); i++) {
            var key = keys[i];
            var isAwailable = SensorsCheckers.check(key);

            if (isAwailable) {
                awailableSensors.add(key);
            }
        }

        return awailableSensors;
    }

    function isAwailable(sensorType as SensorTypes.Enum) as Boolean {
        return self.awailableSensors.indexOf(sensorType) > -1;
    }

    function getValue(sensorType as SensorTypes.Enum) as SensorsGetters.SersorInfoGetterValue {
        if (!self.isAwailable(sensorType)) {
            return null;
        }

        return SensorsGetters.getValue(sensorType);
    }

    function transformValue(sensorType as SensorTypes.Enum) as String {
        return SensorsTransformators.transformValue(sensorType, self.getValue(sensorType));
    }

    function getIcon(sensorType as SensorTypes.Enum) as Toybox.WatchUi.FontResource? {
        var iconSymbol = SensorsIcons.getIcon(sensorType, self.getValue(sensorType));

        return iconSymbol != null ? ResourcesCache.get(iconSymbol) as Toybox.WatchUi.FontResource : null;
    }
}
