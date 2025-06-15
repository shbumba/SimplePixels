import Toybox.Lang;
import Toybox.System;
import SensorsIcons;
import SensorsTransformators;
import SensorsGetters;
import SensorsCheckers;
import ResourcesCache;
import SensorTypes;

class SensorsInfoService {
    private var availableSensors as Dictionary<SensorTypesEnum, Boolean> = {};
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
        var keys = SensorsGetters.Map.keys() as Array<SensorTypesEnum>;

        for (var i = 0; i < keys.size(); i++) {
            var key = keys[i];

            if (SensorsCheckers.check(key)) {
                self.availableSensors.put(key, true);
            }
        }
    }

    function isAvailable(sensorType as SensorTypesEnum) as Boolean {
        return self.availableSensors.hasKey(sensorType);
    }

    function getValue(sensorType as SensorTypesEnum) as SensorsGetters.SensorInfoGetterValue {
        if (!self.isAvailable(sensorType)) {
            return null;
        }

        return SensorsGetters.getValue(sensorType);
    }

    function transformValue(sensorType as SensorTypesEnum) as String {
        return SensorsTransformators.transformValue(sensorType, self.getValue(sensorType));
    }

    function getIcon(sensorType as SensorTypesEnum) as Toybox.WatchUi.FontResource? {
        var iconSymbol = SensorsIcons.getIcon(sensorType, self.getValue(sensorType));

        return iconSymbol != null ? ResourcesCache.get(iconSymbol) as Toybox.WatchUi.FontResource : null;
    }
}
