import Toybox.Lang;
import ObserverModule;

module Services {
    enum ServiceType {
        SENSORS_INFO = 1,
        OBSERVER_STORE
    }

    var _cachedServices = {} as Dictionary<ServiceType, Object>;

    function register() as Void {
        if (_cachedServices.size() > 0) {
            return;
        }

        _cachedServices.put(SENSORS_INFO, new SensorsInfoService());
        _cachedServices.put(OBSERVER_STORE, new ObserverModule.ObserverStore());
    }

    function SensorInfo() as SensorsInfoService {
        return _cachedServices.get(SENSORS_INFO);
    }

    function ObserverStore() as ObserverModule.ObserverStore {
        return _cachedServices.get(OBSERVER_STORE);
    }
}
