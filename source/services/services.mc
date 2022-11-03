import Toybox.Lang;

module Services {
    module ServiceType {
        enum Enum {
            SENSORS_INFO = 1,
            OBSERVED_STORE,
        }
    }

    var _cachedServices = {} as Dictionary<ServiceType.Enum, Object>;

    function register() as Void {
        if (_cachedServices.size() > 0) {
            return;
        }

        _cachedServices.put(ServiceType.SENSORS_INFO, new SensorInfoModule.SensorsInfoService());
        _cachedServices.put(ServiceType.OBSERVED_STORE, new ObservedStoreModule.Store());
    }

    function SensorInfo() as SensorInfoModule.SensorsInfoService {
        return _cachedServices.get(ServiceType.SENSORS_INFO);
    }

    function ObservedStore() as ObservedStoreModule.Store {
        return _cachedServices.get(ServiceType.OBSERVED_STORE);
    }
}