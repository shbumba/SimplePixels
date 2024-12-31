import Toybox.Lang;
import Toybox.System;
import SensorsIcons;
import SensorsTransformators;
import SensorsGetters;
import SensorsCheckers;
import ResourcesCache;

class SensorsInfoService {
    private var awailableSensors as Dictionary<SensorTypes.Enum, Boolean> = {};
    var _isInited = false;

    function init() {
        if (self._isInited) {
            return;
        }

        self.fillAvailableSensors();
        self.cleanChecker();

        self._isInited = true;
    }

    private function cleanChecker() as Void {
        SensorsCheckers.Map = {};
    }

    private function fillAvailableSensors() as Void {
        var keys = SensorsGetters.Map.keys() as Array<SensorTypes.Enum>;

        for (var i = 0; i < keys.size(); i++) {
            var key = keys[i];

            if (SensorsCheckers.check(key)) {
                self.awailableSensors.put(key, true);
            }
        }
    }

    function isAvailable(sensorType as SensorTypes.Enum) as Boolean {
        return self.awailableSensors.hasKey(sensorType);
    }

    function getValue(sensorType as SensorTypes.Enum) as SensorsGetters.SensorInfoGetterValue {
        if (!self.isAvailable(sensorType)) {
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
