import Toybox.Lang;
import Toybox.Background;
import Toybox.Time;

(:background)
class BackgroundController {
    const BG_INTERVAL_LIMIT as Number = 300; // 5 minutes as seconds
    var isRunning as Boolean = false;

    protected function getInterval() as Number {
        return BG_INTERVAL_LIMIT; // Abstract
    }

    protected function isEnabled() as Boolean {
        return false; // Abstract
    }

    function shouldRemoveEvent() as Boolean {
        return !self.isEnabled() && (self.isRunning || Background.getTemporalEventRegisteredTime() != null);
    }

    function setup() as Void {
        if (self.isEnabled()) {
            self.runNow();
        } else if (self.shouldRemoveEvent()) {
            self._remove();
        }
    }

    function scheduleNext() as Void {
        var intervalSeconds = self.getInterval() * 60;
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
        if (!self.isEnabled() || self.shouldRemoveEvent()) {
            return;
        }

        self.isRunning = true;

        Background.registerForTemporalEvent(time);
    }

    function _remove() as Void {
        self.isRunning = false;

        Background.deleteTemporalEvent();
    }
}