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

    typedef FromatDateResult as {
        :month as Lang.Number,
        :day as Lang.Number,
        :enMonthName as Lang.String,
        :numMonthName as Lang.String,
        :dayName as Lang.String
    };

    function formatDate(time as Time.Moment, format as Time.DateFormat?) as FromatDateResult {
        var englishDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
        var englishMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        var numeralsMonths = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];
        var date = Gregorian.info(time, format);

        var month = date.month;
        var day = date.day;
        var enMonthName = englishMonths[month - 1];
        var numMonthName = numeralsMonths[month - 1];
        var dayOfWeek = englishDays[date.day_of_week - 1];

        return {
            :month => month,
            :day => day,
            :enMonthName => enMonthName,
            :numMonthName => numMonthName,
            :dayName => dayOfWeek
        };
    }

    function formatDateByType(time as Time.Moment, type as DisplayDateFormatType.Enum) as Array<String> {
        var formatedDate = formatDate(time, Time.FORMAT_SHORT);

        switch (type) {
            case DisplayDateFormatType.MMDD:
                return (
                    [
                        formatedDate.get(:dayName),
                        formatedDate.get(:numMonthName) + "/" + formatedDate.get(:day).toString()
                    ] as Array<String>
                );
            default:
                return (
                    [
                        formatedDate.get(:dayName),
                        formatedDate.get(:day).toString() + " " + formatedDate.get(:enMonthName)
                    ] as Array<String>
                );
        }
    }
}
