import Toybox.Lang;

module ObservedStore {
    module Scope {
        enum {
            ON_LAYOUT = 1,
            ON_UPDATE,
            ON_PARTIAL_UPDATE,
            ON_SETTINGS_CHANGED,
            ON_NIGHT_MODE_CHANGED,
        }
    }

    class KeyInstance {
        public static var key as String;

        public var scope as Array<Scope> = [Scope.ON_UPDATE];

        function get() as Object? {
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
        private var _keyInstances as Array<KeyInstance> = [];
        private var _cachedResults as Dictionary<KeyInstance, Lang.Object?> = {};

        function setup(keyInstances as Array<KeyInstance>) as Void {
            self._keyInstances = keyInstances;

            var onValueInitQueue = [];

            for (var i = 0; i < self._keyInstances.size(); i++) {
                var instance = self._keyInstances[i];
                var processResult = self.processInstance(instance, true);
                var value = processResult[0];

                onValueInitQueue.add([instance, value]);
            }

            for (var i = 0; i < onValueInitQueue.size(); i++) {
                var instance = onValueInitQueue[i][0];
                var value = onValueInitQueue[i][1];

                instance.onValueInit(value);
            }
        }

        private function processInstance(instance as KeyInstance, isInitial as Boolean) as Array { // [value, prevValue]
            var prevValue = self._cachedResults.get(instance.key);
            var currentValue = instance.get();

            if (prevValue == currentValue && !isInitial) {
                return null;
            }

            self._cachedResults.put(instance.key, currentValue);

            return [currentValue, prevValue];
        }

        function getValue(instance as KeyInstance) as Lang.Object? {
            return self._cachedResults.get(instance.key);
        }

        function runScope(scope as Scope) as Void {
            var onUpdateQueue = [];

            for (var i = 0; i < self._keyInstances.size(); i++) {
                var instance = self._keyInstances[i];

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
                var instance = onUpdateQueue[i][0];
                var currentValue = onUpdateQueue[i][1];
                var prevValue = onUpdateQueue[i][2];

                instance.onValueUpdated(currentValue, prevValue);
            }
        }
    }
}
