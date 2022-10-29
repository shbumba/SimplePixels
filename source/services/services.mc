import Toybox.Lang;

module Services {
    module ServiceType {
        enum {
            SENSORS_INFO = 1,
            OBSERVED_STORE,
        }
    }

    var cachedServices = {};

    function register(serviceType as ServiceType, service as Object) as Void {
        if (cachedServices.hasKey(serviceType)) {
            return;
        }

        cachedServices.put(serviceType, service);
    }

    function get(serviceKey as ServiceType) {
        return cachedServices.get(serviceKey);
    }
}