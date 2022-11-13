import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Time.Gregorian;

class DateView extends Component.Box {
    function initialize(params as Component.BoxProps) {
        Component.Box.initialize(params);
    }

    protected function getDateMonth() as Array<String> { // [dayOfWeek, dayMonth]
        var currentDate = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

        var month = currentDate.month;
        var dayOfWeek = currentDate.day_of_week.substring(0, 3);
        var dayMonth = currentDate.day.toString() + " " + month;

        return [dayOfWeek, dayMonth] as Array<String>;
    }

    protected function render(drawContext as Dc) as Void {
        var position = self.getPosition();
        var boxSize = self.getActualBoxSize();
        var posX = position.get(:x);
        var posY = position.get(:y);
        var width = boxSize.get(:width);
        var height = boxSize.get(:height);

        var dateObj = self.getDateMonth();

        var backgroundColor = Graphics.COLOR_TRANSPARENT;
        var infoColor = self.infoColor;

        var font = self.getFont();
        var fontHeight = drawContext.getFontHeight(font);

        drawContext.setColor(infoColor, backgroundColor);
        drawContext.drawText(
            posX + width,
            posY,
            font,
            dateObj[0],
            Graphics.TEXT_JUSTIFY_RIGHT
        );
        drawContext.drawText(
            posX + width,
            posY + fontHeight,
            font,
            dateObj[1],
            Graphics.TEXT_JUSTIFY_RIGHT
        );
    }
}
