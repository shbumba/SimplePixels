import Toybox.Lang;
import Toybox.Background;
import Toybox.Time;
import SettingsModule.SettingType;
import SettingsModule;

(:background)
class BackgroundController {
    (:background)
    const BG_INTERVAL_LIMIT = 300; // 5 minutes
    (:background)
    var isRunning = false;

    (:background)
    function setup() as Void {
        var isEnabled = !!SettingsModule.getValue(SettingType.OPENWEATHER_ENABLED);

        if (isEnabled) {
            self._run();
        } else if (!isEnabled && self.isRunning) {
            self._remove();
        }
    }

    (:background)
    function next() as Void {
        var interval = SettingsModule.getValue(SettingType.OPENWEATHER_INTERVAL);
        interval = interval != null ? interval : 30;

        var intervalSeconds = interval * 60;
        var nextTime = Time.now().add(new Time.Duration(intervalSeconds));

        self._remove();
        self._registerTask(nextTime);
    }

    (:background)
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

    (:background)
    function _registerTask(time as Time.Moment or Time.Duration) as Void {
        self.isRunning = true;

        Background.registerForTemporalEvent(time);
    }

    (:background)
    function _remove() as Void {
        self.isRunning = false;

        Background.deleteTemporalEvent();
    }
}