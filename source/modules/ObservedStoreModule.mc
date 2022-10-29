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

    typedef ValueItinProps as {
            :value as Lang.Object?
        };

    typedef ValueUpdatedProps as {
            :value as Lang.Object?,
            :prevValue as Lang.Object?
        };

    typedef ProcessInstanceProps as {
            :instance as KeyInstance,
            :isInitial as Boolean
        };

    class KeyInstance {
        public static var key as String;

        public var scope as Array<Scope> = [Scope.ON_UPDATE];

        function get() as Lang.Object? {
            // Abstract
        }

        function onValueInit(props as ValueItinProps) as Void {
            // Abstract
        }

        function onValueUpdated(props as ValueUpdatedProps) as Void {
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
                var processResult = self.processInstance({
                    :instance => instance,
                    :isInitial => true
                });

                onValueInitQueue.add([
                    instance,
                    {
                        :value => processResult.get(:value)
                    }
                ]);
            }

            for (var i = 0; i < onValueInitQueue.size(); i++) {
                var instance = onValueInitQueue[i][0];
                var value = onValueInitQueue[i][1];

                instance.onValueInit(value);
            }
        }

        private function processInstance(props as ProcessInstanceProps) as ValueUpdatedProps? {
            var _instance = props.get(:instance);
            var prevResult = self._cachedResults.get(_instance.key);
            var currentResult = _instance.get();

            if (prevResult == currentResult && !props.get(:isInitial)) {
                return null;
            }

            self._cachedResults.put(_instance.key, currentResult);

            return {
                :value => currentResult,
                :prevValue => prevResult
            };
        }

        function getValue(instance as KeyInstance) as Lang.Object? {
            return self._cachedResults.get(instance.key);
        }

        function runScope(scope as Scope) as Void {
            var onUpdateQueue = [];

            for (var i = 0; i < self._keyInstances.size(); i++) {
                var instance = self._keyInstances[i];

                if (instance.scope.indexOf(scope) < 0) {
                    continue;
                }

                var processResult = self.processInstance({
                    :instance => instance,
                    :isInitial => false
                });

                if (processResult == null) {
                    continue;
                }

                onUpdateQueue.add([instance, processResult]);
            }

            for (var i = 0; i < onUpdateQueue.size(); i++) {
                var instance = onUpdateQueue[i][0];
                var values = onUpdateQueue[i][1];

                instance.onValueUpdated(values);
            }
        }
    }
}
