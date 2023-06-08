import Toybox.Lang;

module WatcherModule {
    enum Scope {
        ON_LAYOUT = 1,
        ON_UPDATE,
        ON_PARTIAL_UPDATE,
        ON_SETTINGS_CHANGED,
        ON_NIGHT_MODE_CHANGED,
        ON_ENTER_SLEEP,
        ON_EXIT_SLEEP
    }

    typedef InstanceKey as String;
    typedef InstanceGetter as Object?;

    class Watcher {
        static var key as String = "";
        var scope as Array<Scope> = [ON_UPDATE];

        function get() as InstanceGetter {
            // Abstract
            return null;
        }

        function onValueInit(value) as Void {
            // Abstract
        }

        function onValueUpdated(value, prevValue) as Void {
            // Abstract
        }
    }

    class Store {
        var _wathers as Array<Watcher> = [];
        var _cachedResults as Dictionary<InstanceKey, InstanceGetter> = {};

        function setup(wathers as Array<Watcher>) as Void {
            self._wathers = wathers;
            var onValueInitQueue = [] as Array;

            for (var i = 0; i < wathers.size(); i++) {
                var instance = wathers[i] as Watcher;
                var processResult = self._processInstance(instance, true);

                if (processResult == null) {
                    continue;
                }

                var value = processResult[0];

                onValueInitQueue.add([instance, value]);
            }

            while (onValueInitQueue.size() > 0) {
                var instance = onValueInitQueue[0][0] as Watcher;
                var value = onValueInitQueue[0][1] as InstanceGetter;

                instance.onValueInit(value);
                onValueInitQueue.remove(onValueInitQueue[0]);
            }
        }

        function _processInstance(instance as Watcher, isInitial as Boolean) as Array? {
            var prevValue = self._cachedResults.get(instance.key);
            var currentValue = instance.get();

            if (prevValue == currentValue && !isInitial) {
                return null;
            }

            self._cachedResults.put(instance.key, currentValue);

            return [currentValue, prevValue];
        }

        function getValue(instanceKey as String) as Lang.Object? {
            return self._cachedResults.get(instanceKey);
        }

        function runScope(scope as Scope) as Void {
            var onUpdateQueue = [] as Array;

            for (var i = 0; i < self._wathers.size(); i++) {
                var instance = self._wathers[i];

                if (instance.scope.indexOf(scope) == -1) {
                    continue;
                }

                var processResult = self._processInstance(instance, false);

                if (processResult == null) {
                    continue;
                }

                var currentValue = processResult[0];
                var prevValue = processResult[1];

                onUpdateQueue.add([instance, currentValue, prevValue]);
            }

            while (onUpdateQueue.size() > 0) {
                var task = onUpdateQueue[0];
                var instance = task[0] as Watcher;
                var currentValue = task[1] as InstanceGetter;
                var prevValue = task[2] as InstanceGetter;

                instance.onValueUpdated(currentValue, prevValue);
                onUpdateQueue.remove(task);
            }
        }
    }
}
