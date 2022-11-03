import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;
import Services;
import SensorInfoModule;
import ObservedStoreModule;
import ObservedStoreModule.Scope;

class SimplePixelsView extends WatchUi.WatchFace {
    private var awakeMemoryKey as AwakeObservedKey;

    function initialize() {
        WatchFace.initialize();
        Services.register();

        self.awakeMemoryKey = new AwakeObservedKey(self, true);
    }

    private function setupStore(drawContext as Dc) as Void {
        Services.ObservedStore().setup([
            self.awakeMemoryKey,
            new DisplaySecondsObservedKey(self),
            new OnSettingsChangedObservedKey(self)
        ] as Array<KeyInstance>);
    }

    function onLayout(drawContext as Dc) as Void {
        WatchFace.onLayout(drawContext);

        WatchFace.setLayout(Rez.Layouts.MainLayout(drawContext));

        self.setupStore(drawContext);
    }

    function onUpdate(drawContext as Dc) as Void {
        Services.ObservedStore().runScope(Scope.ON_UPDATE);

        drawContext.clearClip();
        
        WatchFace.onUpdate(drawContext);
    }

    function onPartialUpdate(drawContext as Dc) as Void {
        Services.ObservedStore().runScope(Scope.ON_PARTIAL_UPDATE);
    
        WatchFace.onPartialUpdate(drawContext);
    }

    function onShow() as Void {
        self.awakeMemoryKey.setIsAwake(true);

        WatchFace.onShow();
    }

    function onEnterSleep() as Void {
        self.awakeMemoryKey.setIsAwake(false);

        WatchFace.onEnterSleep();
        WatchUi.requestUpdate();
    }

    function onExitSleep() as Void {
        self.awakeMemoryKey.setIsAwake(true);

        WatchFace.onExitSleep();
        WatchUi.requestUpdate();
    }

    function onSettingsChanged() as Void {
        Services.ObservedStore().runScope(Scope.ON_SETTINGS_CHANGED);

        WatchUi.requestUpdate();
	}

    function onNightModeChanged() as Void {
        self.awakeMemoryKey.setIsAwake(false);
        Services.ObservedStore().runScope(Scope.ON_NIGHT_MODE_CHANGED);

        WatchUi.requestUpdate();
    }
}
