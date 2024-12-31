import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

module FormatDate {
    module DisplayDateFormatType {
        enum Enum {
            DDMM = 0,
            MMDD = 1
        }
    }

    typedef FormatDateResult as {
        :month as Lang.Number,
        :day as Lang.Number,
        :enMonthName as Lang.String,
        :dayName as Lang.String
    };

    function formatDate(time as Time.Moment, format as Time.DateFormat?) as FormatDateResult {
        var englishDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
        var englishMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        var date = Gregorian.info(time, format);

        var month = date.month;
        var day = date.day;
        var enMonthName = englishMonths[month - 1];
        var dayOfWeek = englishDays[date.day_of_week - 1];

        return {
            :month => month,
            :day => day,
            :enMonthName => enMonthName,
            :dayName => dayOfWeek
        };
    }

    function formatDateByType(time as Time.Moment, type as DisplayDateFormatType.Enum) as Array<String> {
        var formattedDate = formatDate(time, Time.FORMAT_SHORT);

        switch (type) {
            case DisplayDateFormatType.MMDD:
                return (
                    [
                        formattedDate.get(:dayName),
                        formattedDate.get(:month).toString() + "/" + formattedDate.get(:day).toString()
                    ] as Array<String>
                );
            default:
                return (
                    [
                        formattedDate.get(:dayName),
                        formattedDate.get(:day).toString() + " " + formattedDate.get(:enMonthName)
                    ] as Array<String>
                );
        }
    }
}
