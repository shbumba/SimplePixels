import Toybox.Lang;
import Toybox.WatchUi;
import GlobalKeys;

module ResourcesCache {
    var _cache = {} as Dictionary<Symbol, WatchUi.Resource>;

    function get(resourceKey as Symbol) as WatchUi.Resource {
        var resource = _cache.get(resourceKey);

        if (resource == null) {
            resource = WatchUi.loadResource(resourceKey);
        }

        if (GlobalKeys.IS_CACHE_ENABLED) {
            _cache.put(resourceKey, resource);
        }

        return resource;
    }

    function remove(resourceKey as Symbol) as Void {
        _cache.remove(resourceKey);
    }
}
