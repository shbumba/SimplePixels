import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;
import Services;
import WatcherModule;

(:debug)
function printCommonDebugInfo() {
    var deviceSettings = Toybox.System.getDeviceSettings();
    var stats = Toybox.System.getSystemStats();

    Toybox.System.println([deviceSettings.screenShape, deviceSettings.screenWidth, deviceSettings.screenHeight]);
    Toybox.System.println([stats.totalMemory, stats.usedMemory, stats.freeMemory]);
}

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
        WatchFace.setLayout(Rez.Layouts.MainLayout(drawContext));

        self.setupStore(drawContext);

        WatchFace.onLayout(drawContext);
    }

    function onUpdate(drawContext as Dc) as Void {
        drawContext.clearClip();

        Services.WathersStore().runScope(WatcherModule.ON_UPDATE);
        
        WatchFace.onUpdate(drawContext);
    }

    function onPartialUpdate(drawContext as Dc) as Void {
        drawContext.clearClip();
        
        self.awakeWatcher.setIsAwake(false);
    
        Services.WathersStore().runScope(WatcherModule.ON_PARTIAL_UPDATE);
        
        WatchFace.onPartialUpdate(drawContext);
    }

    function onShow() as Void {
        self.awakeWatcher.setIsAwake(true);

        Services.WathersStore().runScope(WatcherModule.ON_EXIT_SLEEP);

        WatchFace.onShow();
    }

    function onEnterSleep() as Void {
        self.awakeWatcher.setIsAwake(false);

        Services.WathersStore().runScope(WatcherModule.ON_ENTER_SLEEP);

        WatchFace.onEnterSleep();
    }

    function onExitSleep() as Void {
        self.awakeWatcher.setIsAwake(true);

        Services.WathersStore().runScope(WatcherModule.ON_EXIT_SLEEP);

        WatchFace.onExitSleep();
    }

    function onNightModeChanged() as Void {
        self.awakeWatcher.setIsAwake(false);

        Services.WathersStore().runScope(WatcherModule.ON_NIGHT_MODE_CHANGED);
    }

    function onSettingsChanged() as Void {
        Services.WathersStore().runScope(WatcherModule.ON_SETTINGS_CHANGED);
	}
}
