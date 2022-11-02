import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Time.Gregorian;

class DateView extends Component.Box {
    function initialize(params as Dictionary<String, String?>) {
        Component.Box.initialize(params);
    }

    protected function getDateMonth() as {
        :dayOfWeek as String,
        :dayMonth as String
    } {
        var currentDate = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

        var month = currentDate.month;
        var dayOfWeek = currentDate.day_of_week.substring(0, 3);
        var dayMonth = currentDate.day.toString() + " " + month;

        return {
            :dayOfWeek => dayOfWeek,
            :dayMonth => dayMonth
        };
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
        var textColor = self.textColor;

        var font = self.getFont();
        var fontHeight = drawContext.getFontHeight(font);

        drawContext.setColor(textColor, backgroundColor);
        drawContext.drawText(
            posX + width,
            posY,
            font,
            dateObj.get(:dayOfWeek),
            Graphics.TEXT_JUSTIFY_RIGHT
        );
        drawContext.drawText(
            posX + width,
            posY + fontHeight,
            font,
            dateObj.get(:dayMonth),
            Graphics.TEXT_JUSTIFY_RIGHT
        );
    }
}
