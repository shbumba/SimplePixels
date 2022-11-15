import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import SettingsModule;
import SettingsModule.DisplaySecondsType;
import Components;

class SecondsView extends Components.Box {
    function initialize(params as Components.BoxProps) {
        Components.Box.initialize(params);
    }

    protected function getSeconds() as String {
        return System.getClockTime().sec.format("%02d");
    }

    function setViewProps(displaySecondsType as DisplaySecondsType.Enum, isAwake as Boolean) as Void {
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
        drawContext.setColor(self.foregroundColor, self.backgroundColor);
        drawContext.drawText(
            self.getPosX(),
            self.getPosY(),
            self.getFont(),
            self.getSeconds(),
            Graphics.TEXT_JUSTIFY_LEFT
        );
    }
}
