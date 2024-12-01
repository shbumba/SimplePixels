import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

function formatDate(time as Time.Moment) as Array<String> {
    var englishDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    var date = Gregorian.info(time, Time.FORMAT_SHORT);
    var dayOfWeek = englishDays[date.day_of_week - 1];
    var dayMonth = "";
    switch (SettingsModule.getValue(SettingsModule.SettingType.DATE_FORMAT)) {
        case 1:
            dayMonth = formatDateToMMdd(date.month, date.day.toString());
            break;
        default:
            dayMonth = formatDateToEng(date.month, date.day.toString());
            break;
    }
    return [dayOfWeek, dayMonth] as Array<String>;
}

function formatDateToEng(month as Number, day as String) as String {
    var englishMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return day + " " + englishMonths[month - 1];
}

function formatDateToMMdd(month as Number, day as String) as String {
    var numeralsMonths = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];
    return numeralsMonths[month - 1] + "/" + day;
}
