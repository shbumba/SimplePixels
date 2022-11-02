import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import SettingsModule;
import SettingsModule.DisplaySecondsType;

class SecondsView extends Component.Box {
    function initialize(params as Component.BoxProps) {
        Component.Box.initialize(params);
    }

    protected function getSeconds() as Number {
        var seconds = System.getClockTime().sec;

        return seconds;
    }

    function setViewProps(displaySecondsType as DisplaySecondsType, isAwake as Boolean) as Void {
        switch (displaySecondsType) {
            case DisplaySecondsType.NEVER:
                self.setVisible(false);
            break;
            case DisplaySecondsType.ON_GESTURE:
                self.setVisible(isAwake);
            break;
        }
    }

    protected function render(drawContext as Dc) as Void {
        var position = self.getPosition();
        var posX = position.get(:x);
        var posY = position.get(:y);

        var seconds = self.getSeconds().format("%02d");

        var backgroundColor = self.backgroundColor;
        var foregroundColor = self.foregroundColor;
        var boxSize = self.getActualBoxSize();

        drawContext.setColor(foregroundColor, backgroundColor);
        drawContext.drawText(posX, posY, self.getFont(), seconds, Graphics.TEXT_JUSTIFY_LEFT);
    }
}
