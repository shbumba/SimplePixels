import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;
import Services;
import Services.ServiceType;
import SensorInfoModule;
import ObservedStore;
import ObservedStore.Scope;

class SimplePixelsView extends WatchUi.WatchFace {
    private var awakeMemoryKey as AwakeObservedKey;
    private var memoryStore as ObservedStore.Store;

    function initialize() {
        WatchFace.initialize();
        self.initServices();
    }

    private function initServices() as Void {
        self.memoryStore = new ObservedStore.Store();
        
        Services.register(ServiceType.SENSORS_INFO, new SensorInfoModule.SensorsInfoService());
        Services.register(ServiceType.OBSERVED_STORE, self.memoryStore);
    }

    private function setupStore(drawContext as Dc) as Void {
        self.awakeMemoryKey = new AwakeObservedKey({
            :mainView => self,
            :isAwake => true
        });

        self.memoryStore.setup([
            self.awakeMemoryKey,
            new DisplaySecondsObservedKey(self),
            new OnSettingsChangedObservedKey(self)
        ]);
    }

    function onLayout(drawContext as Dc) as Void {
        View.setLayout(Rez.Layouts.MainLayout(drawContext));

        self.setupStore(drawContext);
    }

    function onUpdate(drawContext as Dc) as Void {
        drawContext.clearClip();

        self.memoryStore.runScope(Scope.ON_UPDATE);
        
        View.onUpdate(drawContext);
    }

    function onPartialUpdate(drawContext as Dc) as Void {
        self.memoryStore.runScope(Scope.ON_PARTIAL_UPDATE);
    }

    function onShow() as Void {
        self.awakeMemoryKey.setIsAwake(true);

        WatchUi.requestUpdate();
    }

    function onEnterSleep() as Void {
        self.awakeMemoryKey.setIsAwake(false);

        WatchUi.requestUpdate();
    }

    function onExitSleep() as Void {
        self.awakeMemoryKey.setIsAwake(true);

        WatchUi.requestUpdate();
    }

    function onSettingsChanged() {
        self.memoryStore.runScope(Scope.ON_SETTINGS_CHANGED);

        WatchUi.requestUpdate();
	}

    function onNightModeChanged(drawContext) {
        self.awakeMemoryKey.setIsAwake(false);
        self.memoryStore.runScope(Scope.ON_NIGHT_MODE_CHANGED);

        WatchUi.requestUpdate();
    }
}
