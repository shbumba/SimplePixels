import Toybox.Lang;

module ObserverModule {
    enum Scope {
        ON_LAYOUT = 1,
        ON_UPDATE,
        ON_PARTIAL_UPDATE,
        ON_SETTINGS_CHANGED,
        ON_NIGHT_MODE_CHANGED,
        ON_ENTER_SLEEP,
        ON_EXIT_SLEEP
    }

    typedef InstanceKey as Symbol;
    typedef InstanceGetter as Object?;

    class ValueObserver {
        static var key as InstanceKey = :valueObserver;
        var scope as Array<Scope> = [ON_UPDATE];

        private var _onValueUpdatedCallback as Method? = null;

        function initialize(onValueUpdated as Method?) {
            self._onValueUpdatedCallback = onValueUpdated;
        }

        function getObservedValue() as InstanceGetter {
            // Abstract
            return null;
        }

        private function _callValueCallback(value, prevValue as Null) as Void {
            if (self._onValueUpdatedCallback != null) {
                self._onValueUpdatedCallback.invoke(value, prevValue);
            }
        }

        function onValueInit(value, prevValue as Null) as Void {
            self._callValueCallback(value, prevValue);
        }

        function onValueUpdated(value, prevValue) as Void {
            self._callValueCallback(value, prevValue);
        }
    }

    class ObserverStore {
        var _observers as Array<ValueObserver> = [];
        var _cachedResults as Dictionary<InstanceKey, InstanceGetter> = {};

        function setup(observers as Array<ValueObserver>) as Void {
            self._observers = observers;
            var onValueInitQueue = [] as Array;

            for (var i = 0; i < observers.size(); i++) {
                var instance = observers[i] as ValueObserver;
                var processResult = self._processInstance(instance, true);

                if (processResult == null) {
                    continue;
                }

                var value = processResult[0];

                onValueInitQueue.add([instance, value]);
            }

            while (onValueInitQueue.size() > 0) {
                var instance = onValueInitQueue[0][0] as ValueObserver;
                var value = onValueInitQueue[0][1] as InstanceGetter;

                instance.onValueInit(value, null);
                onValueInitQueue.remove(onValueInitQueue[0]);
            }
        }

        function _processInstance(instance as ValueObserver, isInitial as Boolean) as Array? {
            var prevValue = self._cachedResults.get(instance.key);
            var currentValue = instance.getObservedValue();

            if (prevValue == currentValue && !isInitial) {
                return null;
            }

            self._cachedResults.put(instance.key, currentValue);

            return [currentValue, prevValue];
        }

        function getValue(instanceKey as InstanceKey) as Lang.Object? {
            return self._cachedResults.get(instanceKey);
        }

        function runScope(scope as Scope) as Void {
            var onUpdateQueue = [] as Array;

            for (var i = 0; i < self._observers.size(); i++) {
                var instance = self._observers[i];

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
                var instance = task[0] as ValueObserver;
                var currentValue = task[1] as InstanceGetter;
                var prevValue = task[2] as InstanceGetter;

                instance.onValueUpdated(currentValue, prevValue);
                onUpdateQueue.remove(task);
            }
        }
    }
}
