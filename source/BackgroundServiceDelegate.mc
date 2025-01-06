import Toybox.Lang;
import Toybox.Background;
import Toybox.System;

(:background)
class BackgroundServiceDelegate extends System.ServiceDelegate {
    (:background)
    var _owServiceDelegate = false;

    function initialize() {
        System.ServiceDelegate.initialize();

        self._owServiceDelegate = new OWBackgroundServiceDelegate();
    }

    (:background)
    function onTemporalEvent() as Void {
        self._owServiceDelegate.onTemporalEvent();
    }
}
