import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;
import Services;
import SensorInfoModule;
import WatcherModule;

class SimplePixelsView extends WatchUi.WatchFace {
    private var awakeWatcher as AwakeWatcher;

    function initialize() {
        WatchFace.initialize();
        Services.register();

        self.awakeWatcher = new AwakeWatcher(self, true);
    }

    private function setupStore(drawContext as Dc) as Void {
        Services.WathersStore().setup([
            self.awakeWatcher,
            new DisplaySecondsWatcher(self),
            new OnSettingsChangedWatcher(self)
        ] as Array<Watcher>);
    }

    function onLayout(drawContext as Dc) as Void {
        WatchFace.onLayout(drawContext);

        WatchFace.setLayout(Rez.Layouts.MainLayout(drawContext));

        self.setupStore(drawContext);
    }

    function onUpdate(drawContext as Dc) as Void {
        Services.WathersStore().runScope(WatcherModule.ON_UPDATE);

        drawContext.clearClip();
        
        WatchFace.onUpdate(drawContext);
    }

    function onPartialUpdate(drawContext as Dc) as Void {
        Services.WathersStore().runScope(WatcherModule.ON_PARTIAL_UPDATE);
    
        WatchFace.onPartialUpdate(drawContext);
    }

    function onShow() as Void {
        self.awakeWatcher.setIsAwake(true);

        WatchFace.onShow();
    }

    function onEnterSleep() as Void {
        self.awakeWatcher.setIsAwake(false);

        WatchFace.onEnterSleep();
        WatchUi.requestUpdate();
    }

    function onExitSleep() as Void {
        self.awakeWatcher.setIsAwake(true);

        WatchFace.onExitSleep();
        WatchUi.requestUpdate();
    }

    function onSettingsChanged() as Void {
        Services.WathersStore().runScope(WatcherModule.ON_SETTINGS_CHANGED);

        WatchUi.requestUpdate();
	}

    function onNightModeChanged() as Void {
        self.awakeWatcher.setIsAwake(false);
        Services.WathersStore().runScope(WatcherModule.ON_NIGHT_MODE_CHANGED);

        WatchUi.requestUpdate();
    }
}
