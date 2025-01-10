import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import SettingsModule;
import SettingsModule.DisplaySecondsType;
import Components;

class SecondsView extends Components.Box {
    var _displaySecondsType as DisplaySecondsType.Enum = DisplaySecondsType.NEVER;
    var _isAwake as Boolean = AwakeObserver.isAwake;

    function initialize(params as Components.BoxProps) {
        Components.Box.initialize(params);

        self.updateSettings();
        self.setVisibility();
    }

    protected function getSeconds() as String {
        return System.getClockTime().sec.format("%02d");
    }

    function onSettingsChanged() as Void {
        Components.Box.onSettingsChanged();

        self.updateSettings();
        self.setVisibility();
    }

    private function updateSettings() as Void {
        self._displaySecondsType =
            SettingsModule.getValue(SettingsModule.SettingType.DISPLAY_SECONDS) as DisplaySecondsType.Enum;
    }

    function setViewProps(isAwake as Boolean) as Void {
        self._isAwake = isAwake;
        self.setVisibility();
    }

    function setVisibility() as Void {
        switch (self._displaySecondsType) {
            case DisplaySecondsType.NEVER:
                self.setVisible(false);
                break;
            case DisplaySecondsType.ON_GESTURE:
                self.setVisible(self._isAwake);
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
