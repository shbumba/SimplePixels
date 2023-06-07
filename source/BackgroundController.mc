import Toybox.Lang;
import Toybox.Background;
import Toybox.Time;
import SettingsModule.SettingType;
import SettingsModule;

class BackgroundController {
    const BG_INTERVAL_LIMIT = 300; // 5 minutes as seconds
    var isRunning = false;

    function setup() as Void {
        var isEnabled = !!SettingsModule.getValue(SettingType.OPENWEATHER_ENABLED);

        if (isEnabled) {
            self._run();
        } else if (!isEnabled && self.isRunning) {
            self._remove();
        }
    }

    function next() as Void {
        var intervalMinutes = SettingsModule.getValue(SettingType.OPENWEATHER_INTERVAL);
        intervalMinutes = intervalMinutes != null ? intervalMinutes : 30;

        var intervalSeconds = intervalMinutes * 60;
        var nextTime = Time.now().add(new Time.Duration(intervalSeconds));

        self._remove();
        self._registerTask(nextTime);
    }

    function _run() as Void {
        var lastTime = Background.getLastTemporalEventTime();
        var nextTime = Time.now();

        if (lastTime != null) {
            // run ASAP
            nextTime = lastTime.add(new Time.Duration(self.BG_INTERVAL_LIMIT));
        }

        self._remove();
        self._registerTask(nextTime);
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