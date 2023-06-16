import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Components;

class PMView extends Components.Box {
    function initialize(params as Components.BoxProps) {
        Components.Box.initialize(params);
    }

    protected function getPM() as String {
        var currentDate = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

        return currentDate.hour >= 12 ? "pm" : "am";
    }

    protected function render(drawContext as Dc) as Void {
        if (GlobalKeys.IS_24_HOUR) {
            return;
        }

        drawContext.setColor(self.foregroundColor, Graphics.COLOR_TRANSPARENT);
        drawContext.drawText(self.getPosX(), self.getPosY(), self.getFont(), self.getPM(), Graphics.TEXT_JUSTIFY_LEFT);
    }
}
