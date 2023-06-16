
import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

function formatDateToEng(time as Time.Moment) as Array<String> {
    var englishMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    var englishDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    var date = Gregorian.info(time, Time.FORMAT_SHORT);

    var month = englishMonths[date.month - 1];
    var dayOfWeek = englishDays[date.day_of_week - 1];
    var dayMonth = date.day.toString() + " " + month;

    return [dayOfWeek, dayMonth] as Array<String>;
}