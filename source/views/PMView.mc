import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;

class PMView extends Component.Box {
    protected var _is24hour as Boolean;

    function initialize(params as Dictionary<String, String?>) {
        Component.Box.initialize(params);

        self.update24Hours();
    }

    private function update24Hours() {
        self._is24hour = System.getDeviceSettings().is24Hour;
    }

    function onSettingsChanged() {
        Component.Box.onSettingsChanged();

        self.update24Hours();
    }

    protected function getPM() as String {
        var currentDate = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

        return currentDate.hour >= 12 ? "pm" : "am";
    }

    protected function render(drawContext as Dc) as Void {
        if (self._is24hour) {
            return;
        }

        var position = self.getPosition();
        var posX = position.get(:x);
        var posY = position.get(:y);

        var pm = self.getPM();

        var backgroundColor = Graphics.COLOR_TRANSPARENT;
        var foregroundColor = self.foregroundColor;
        var boxSize = self.getActualBoxSize();

        drawContext.setColor(foregroundColor, backgroundColor);
        drawContext.drawText(posX, posY, self._font, pm, Graphics.TEXT_JUSTIFY_LEFT);
    }
}
