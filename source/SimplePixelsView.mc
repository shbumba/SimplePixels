import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;
import Services;
import ObserverModule;
import GlobalKeys;
import SettingsModule;

class SimplePixelsView extends WatchUi.WatchFace {
    private var _wasShowed = false;

    function initialize() {
        WatchFace.initialize();
        GlobalKeys.initSettings();
        Services.register();
    }

    function _onConnectionChanged(
        value as ObserverModule.InstanceGetter,
        prevValue as ObserverModule.InstanceGetter
    ) as Void {
        OWBackgroundController.setup();
    }

    function _onAwakeChanged(
        value as ObserverModule.InstanceGetter,
        prevValue as ObserverModule.InstanceGetter
    ) as Void {
        var secondsView = self.findDrawableById(ViewsKeys.SECONDS) as SecondsView;
        var topSensorView = self.findDrawableById(ViewsKeys.TOP_SENSORS) as RightSensorsView;
        var bottomSensorView = self.findDrawableById(ViewsKeys.BOTTOM_SENSORS) as RightSensorsView;
        var prevHoursView = self.findDrawableById(ViewsKeys.PREV_HOURS) as PhantomTimeView;
        var nextHoursView = self.findDrawableById(ViewsKeys.NEXT_HOURS) as PhantomTimeView;
        var leftSensorsView = self.findDrawableById(ViewsKeys.LEFT_SENSORS) as LeftSensorsView;
        var infoBarView = self.findDrawableById(ViewsKeys.INFO_BAR) as InfoBarView;
        var dateView = self.findDrawableById(ViewsKeys.DATE) as DateView;
        var hoursView = self.findDrawableById(ViewsKeys.HOURS) as Components.TimeView;
        var minutesView = self.findDrawableById(ViewsKeys.MINUTES) as Components.TimeView;
        var pmView = self.findDrawableById(ViewsKeys.PM) as PMView;
        var backgroundView = self.findDrawableById(ViewsKeys.BACKGROUND) as BackgroundView;

        secondsView.setViewProps(value as Boolean);
        topSensorView.setViewProps(value as Boolean);
        bottomSensorView.setViewProps(value as Boolean);
        prevHoursView.setViewProps(value as Boolean);
        nextHoursView.setViewProps(value as Boolean);
        leftSensorsView.setViewProps(value as Boolean);
        infoBarView.setViewProps(value as Boolean);
        dateView.setViewProps(value as Boolean);
        hoursView.setViewProps(value as Boolean);
        minutesView.setViewProps(value as Boolean);
        pmView.setViewProps(value as Boolean);
        backgroundView.setViewProps(value as Boolean);

        WatchUi.requestUpdate();
    }

    function onInit(drawContext as Dc) as Void {
        Services.ObserverStore().setup(
            [
                new AwakeObserver(self.method(:_onAwakeChanged), true),
                new ConnectionObserverObserver(self.method(:_onConnectionChanged))
            ] as Array<ValueObserver>
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

        Services.ObserverStore().runScope(ObserverModule.ON_UPDATE);

        WatchFace.onUpdate(drawContext);

        if (!GlobalKeys.IS_NEW_SDK) {
            Services.SensorInfo().init();
        }
    }

    function onPartialUpdate(drawContext as Dc) as Void {
        drawContext.clearClip();

        AwakeObserver.isAwake = false;
        Services.ObserverStore().runScope(ObserverModule.ON_PARTIAL_UPDATE);

        WatchFace.onPartialUpdate(drawContext);
    }

    function onShow() as Void {
        if (!self._wasShowed) {
            self._wasShowed = true;
        } else {
            // need to skip the initial rendering but update global attributes next time
            GlobalKeys.initSettings();
        }

        AwakeObserver.isAwake = true;
        Services.ObserverStore().runScope(ObserverModule.ON_EXIT_SLEEP);

        WatchFace.onShow();
    }

    function onEnterSleep() as Void {
        AwakeObserver.isAwake = false;
        Services.ObserverStore().runScope(ObserverModule.ON_ENTER_SLEEP);

        WatchFace.onEnterSleep();
    }

    function onExitSleep() as Void {
        AwakeObserver.isAwake = true;
        Services.ObserverStore().runScope(ObserverModule.ON_EXIT_SLEEP);

        WatchFace.onExitSleep();
    }

    function onNightModeChanged() as Void {
        AwakeObserver.isAwake = false;
        Services.ObserverStore().runScope(ObserverModule.ON_NIGHT_MODE_CHANGED);
    }

    function onSettingsChanged() as Void {
        Services.ObserverStore().runScope(ObserverModule.ON_SETTINGS_CHANGED);

        var viewValues = ViewsKeys.VALUES;

        for (var i = 0; i < viewValues.size(); i++) {
            var id = viewValues[i] as String;
            var view = self.findDrawableById(id);

            (view as Components.BaseDrawable).onSettingsChanged();
        }

        WatchUi.requestUpdate();
    }
}
