import Toybox.Lang;
import Toybox.Background;
import Toybox.Time;
import SettingsModule.SettingType;
import SettingsModule;

class BackgroundController {
    const BG_INTERVAL_LIMIT as Number = 300; // 5 minutes as seconds
    var isRunning as Boolean = false;

    function setup() as Void {
        var isEnabled = !!SettingsModule.getValue(SettingType.OW_ENABLED);

        if (isEnabled) {
            self.runNow();
        } else if (!isEnabled && self.isRunning) {
            self._remove();
        }
    }

    function scheduleNext() as Void {
        var intervalMinutes = SettingsModule.getValue(SettingType.OW_INTERVAL);
        intervalMinutes = intervalMinutes != null ? intervalMinutes : 30;

        var intervalSeconds = intervalMinutes * 60;
        var nextTime = Time.now().add(new Time.Duration(intervalSeconds));

        self._run(nextTime);
    }

    function runNow() as Void {
        var lastTime = Background.getLastTemporalEventTime();
        var nextTime = Time.now();

        if (lastTime != null) {
            // run ASAP
            nextTime = lastTime.add(new Time.Duration(self.BG_INTERVAL_LIMIT));
        }

        self._run(nextTime);
    }

    function _run(time as Time.Moment or Time.Duration) as Void {
        self._remove();
        self._registerTask(time);
    }

    function _registerTask(time as Time.Moment or Time.Duration) as Void {
        self.isRunning = true;

        Background.registerForTemporalEvent(time);
    }

    function _remove() as Void {
        self.isRunning = false;

        Background.deleteTemporalEvent();
    }
}