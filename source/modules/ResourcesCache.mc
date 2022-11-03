import Toybox.Lang;
import Toybox.WatchUi;

module ResourcesCache {
    var _cache = {};

    function get(resourceKey as Symbol) as Resource {
        var resource = _cache.get(resourceKey);

        if (resource == null) {
            resource = WatchUi.loadResource(resourceKey);
            _cache.put(resourceKey, resource);
        }
        
        return resource;
    }

    function remove(resourceKey as Symbol) as Void {
        _cache.remove(resourceKey);
    }
}
