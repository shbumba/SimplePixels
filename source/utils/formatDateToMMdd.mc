import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

function formatDateToMMdd(time as Time.Moment) as Array<String> {
    var englishDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    var date = Gregorian.info(time, Time.FORMAT_SHORT);
    var dayOfWeek = englishDays[date.day_of_week - 1];
    var dayMonth = date.month.toString() + "/" + date.day.toString();

    return [dayOfWeek, dayMonth] as Array<String>;
}
