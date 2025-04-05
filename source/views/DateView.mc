import Toybox.Lang;
import Toybox.Graphics;
import Toybox.Time;
import Components;
import SettingsModule;
import SettingsModule.SettingType;

class DateView extends Components.Box {
    var _isAwake as Boolean = AwakeObserver.isAwake;
    private var _dateFormatType as FormatDate.DisplayDateFormatType.Enum = FormatDate.DisplayDateFormatType.DDMM;

    function initialize(params as Components.BoxProps) {
        Components.Box.initialize(params);
        self.updateDateFormatType();
    }

    function onSettingsChanged() as Void {
        Components.Box.onSettingsChanged();
        self.updateDateFormatType();
    }

    private function updateDateFormatType() as Void {
        self._dateFormatType =
            SettingsModule.getValue(SettingType.DATE_FORMAT) as FormatDate.DisplayDateFormatType.Enum;
    }

    protected function render(drawContext as Dc) as Void {
        var posX = self.getPosX();
        var posY = self.getPosY();
        var width = self.getWidth();

        var dateObj = FormatDate.formatDateByType(Time.now(), self._dateFormatType);

        var font = self.getFont();
        var fontHeight = drawContext.getFontHeight(font);
        if (!self._isAwake) {
            drawContext.setColor(self.aodColor, Graphics.COLOR_TRANSPARENT);
        } else {
            drawContext.setColor(self.infoColor, Graphics.COLOR_TRANSPARENT);
        }

        drawContext.drawText(posX + width, posY, font, dateObj[0], Graphics.TEXT_JUSTIFY_RIGHT);
        // if (!self._isAwake) {
        //     var pattern = DotPattern.get(DotPattern.DATE, width, height, Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        //     drawContext.drawBitmap(posX + width, posY, pattern);
        // }
        drawContext.drawText(posX + width, posY + fontHeight, font, dateObj[1], Graphics.TEXT_JUSTIFY_RIGHT);
        // if (!self._isAwake) {
        //     var pattern = DotPattern.get(DotPattern.DATE, width, height, Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        //     drawContext.drawBitmap(posX + width, posY + fontHeight - GlobalKeys.AMOLED_Y_OFFSET, pattern);
        // }
    }

    function setViewProps(isAwake as Boolean) as Void {
        self._isAwake = isAwake;
        // self.setVisibility();
    }

    function setVisibility() as Void {
        // self.setVisible(self._isAwake);
        if (!self._isAwake) {
            DotPattern.create(
                DotPattern.DATE,
                self.getWidth(),
                self.getHeight(),
                self.aodColor,
                Graphics.COLOR_TRANSPARENT
            );
        } else {
            // self.updateProps();
        }
    }
}
