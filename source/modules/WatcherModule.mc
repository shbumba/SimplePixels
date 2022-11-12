import Toybox.Lang;

module WatcherModule {
    enum Scope {
        ON_LAYOUT = 1,
        ON_UPDATE,
        ON_PARTIAL_UPDATE,
        ON_SETTINGS_CHANGED,
        ON_NIGHT_MODE_CHANGED,
    }

    typedef InstanceKey as String;
    typedef InstanceGetter as Object?;

    class Watcher {
        public static var key as String = "";

        public var scope as Array<Scope> = [ON_UPDATE] as Array<Scope>;

        function get() as InstanceGetter {
            return null;
            // Abstract
        }

        function onValueInit(value) as Void {
            // Abstract
        }

        function onValueUpdated(value, prevValue) as Void {
            // Abstract
        }
    }

    class Store {
        private var _wathers as Array<Watcher> = [] as Array<Watcher>;
        private var _cachedResults as Dictionary<InstanceKey, InstanceGetter> = {} as Dictionary<InstanceKey, InstanceGetter>;

        function setup(wathers as Array<Watcher>) as Void {
            self._wathers = wathers;

            var onValueInitQueue = [] as Array;

            for (var i = 0; i < wathers.size(); i++) {
                var instance = wathers[i] as Watcher;
                var processResult = self.processInstance(instance, true);

                if (processResult == null) {
                    continue;
                }

                var value = processResult[0];

                onValueInitQueue.add([instance, value]);
            }

            for (var i = 0; i < onValueInitQueue.size(); i++) {
                var instance = onValueInitQueue[i][0] as Watcher;
                var value = onValueInitQueue[i][1] as InstanceGetter;

                instance.onValueInit(value);
            }
        }

        private function processInstance(instance as Watcher, isInitial as Boolean) as Array or Null { // [value, prevValue]
            var prevValue = self._cachedResults.get(instance.key);
            var currentValue = instance.get();

            if (prevValue == currentValue && !isInitial) {
                return null;
            }

            self._cachedResults.put(instance.key, currentValue);

            return [currentValue, prevValue];
        }

        function getValue(instance as Watcher) as Lang.Object? {
            return self._cachedResults.get(instance.key);
        }

        function runScope(scope as Scope) as Void {
            var onUpdateQueue = [] as Array;

            for (var i = 0; i < self._wathers.size(); i++) {
                var instance = self._wathers[i] as Watcher;

                if (instance.scope.indexOf(scope) == -1) {
                    continue;
                }

                var processResult = self.processInstance(instance, false);

                if (processResult == null) {
                    continue;
                }

                var currentValue = processResult[0];
                var prevValue = processResult[1];

                onUpdateQueue.add([instance, currentValue, prevValue]);
            }

            for (var i = 0; i < onUpdateQueue.size(); i++) {
                var instance = onUpdateQueue[i][0] as Watcher;
                var currentValue = onUpdateQueue[i][1] as InstanceGetter;
                var prevValue = onUpdateQueue[i][2] as InstanceGetter;

                instance.onValueUpdated(currentValue, prevValue);
            }
        }
    }
}
