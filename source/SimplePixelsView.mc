import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;
import Services;
import WatcherModule;
import GlobalKeys;

class SimplePixelsView extends WatchUi.WatchFace {
    function initialize() {
        WatchFace.initialize();
        Services.register();
        GlobalKeys.initSettings();
    }

    function onInit(drawContext as Dc) as Void {    
        Services.WathersStore().setup(
            [new AwakeWatcher(self, true), new DisplaySecondsWatcher(self), new OnSettingsChangedWatcher(self)] as
                Array<Watcher>
        );

        if (GlobalKeys.IS_NEW_SDK) {
            Services.SensorInfo().init();
        }
    }

    function onLayout(drawContext as Dc) as Void {
        WatchFace.setLayout(Rez.Layouts.MainLayout(drawContext));

        self.onInit(drawContext);
    }

    function onUpdate(drawContext as Dc) as Void {
        drawContext.clearClip();

        Services.WathersStore().runScope(WatcherModule.ON_UPDATE);

        WatchFace.onUpdate(drawContext);

        if (!GlobalKeys.IS_NEW_SDK) {
            Services.SensorInfo().init();
        }
    }

    function onPartialUpdate(drawContext as Dc) as Void {
        drawContext.clearClip();

        AwakeWatcher.isAwake = false;
        Services.WathersStore().runScope(WatcherModule.ON_PARTIAL_UPDATE);

        WatchFace.onPartialUpdate(drawContext);
    }

    function onShow() as Void {
        AwakeWatcher.isAwake = true;
        Services.WathersStore().runScope(WatcherModule.ON_EXIT_SLEEP);

        WatchFace.onShow();
    }

    function onEnterSleep() as Void {
        AwakeWatcher.isAwake = false;
        Services.WathersStore().runScope(WatcherModule.ON_ENTER_SLEEP);

        WatchFace.onEnterSleep();
    }

    function onExitSleep() as Void {
        AwakeWatcher.isAwake = true;
        Services.WathersStore().runScope(WatcherModule.ON_EXIT_SLEEP);

        WatchFace.onExitSleep();
    }

    function onNightModeChanged() as Void {
        AwakeWatcher.isAwake = false;
        Services.WathersStore().runScope(WatcherModule.ON_NIGHT_MODE_CHANGED);
    }

    function onSettingsChanged() as Void {
        Services.WathersStore().runScope(WatcherModule.ON_SETTINGS_CHANGED);
    }
}
