import Toybox.Lang;
import Toybox.Time;
import Toybox.Test;

(:test)
function isSleepTimeTest(logger as Test.Logger) as Boolean {
    var midnight = Time.today();
    var times = [
        {
            :sleep => new Time.Duration(3600 * 22), // 22:00
            :wake => new Time.Duration(Time.Gregorian.SECONDS_PER_HOUR * 10) // 10:00
        },
        {
            :sleep => new Time.Duration(Time.Gregorian.SECONDS_PER_MINUTE * 30), // 00:30
            :wake => new Time.Duration(Time.Gregorian.SECONDS_PER_HOUR * 10) // 10:00
        }
    ];
    var currentTimes = [
        midnight.add(new Time.Duration(Time.Gregorian.SECONDS_PER_HOUR)), // 01:00
        midnight.add(new Time.Duration(Time.Gregorian.SECONDS_PER_HOUR * 11)), // 11:00
        midnight.add(new Time.Duration(Time.Gregorian.SECONDS_PER_HOUR * 23)), // 23:00
        midnight.add(new Time.Duration(Time.Gregorian.SECONDS_PER_MINUTE * 10)) // 00:10
    ];

    // 22:00 -> 01:00 -> 10:00 => true
    // 00:30 -> 01:00 -> 10:00 => true

    // 22:00 -> 11:00 -> 10:00 => false
    // 00:30 -> 11:00 -> 10:00 => false

    // 22:00 -> 23:00 -> 10:00 => true
    // 00:30 -> 23:00 -> 10:00 => false

    // 22:00 -> 00:10 -> 10:00 => true
    // 00:30 -> 00:10 -> 10:00 => false
    var expectResults = [true, true, false, false, true, false, true, false];
    var result = 0;

    for (var i = 0; i < currentTimes.size(); i++) {
        var currentTime = currentTimes[i];

        for (var i2 = 0; i2 < times.size(); i2++) {
            var interval = times[i2];
            var sleetTime = interval.get(:sleep);
            var wakeTime = interval.get(:wake);
            var isSleep = SensorsGetter.Getters.isSleepTime(
                sleetTime,
                wakeTime,
                currentTime,
                midnight
            );

            var sleetTimeFormated = Time.Gregorian.info(midnight.add(sleetTime), Time.FORMAT_SHORT);
            var currentTimeFormated = Time.Gregorian.info(currentTime, Time.FORMAT_SHORT);
            var wakeTimeFormated = Time.Gregorian.info(midnight.add(wakeTime), Time.FORMAT_SHORT);

            var formatedResult = Lang.format("$1$:$2$ -> $3$:$4$ -> $5$:$6$ => $7$ == $8$", [
                sleetTimeFormated.hour.format("%02u"),
                sleetTimeFormated.min.format("%02u"),
                currentTimeFormated.hour.format("%02u"),
                currentTimeFormated.min.format("%02u"),
                wakeTimeFormated.hour.format("%02u"),
                wakeTimeFormated.min.format("%02u"),
                expectResults[result] ? "true" : "false",
                isSleep ? "true" : "false"
            ]);

            logger.debug(formatedResult);
            Test.assertEqualMessage(
                expectResults[result],
                isSleep,
                "indexResult: [" + result + "] is not equal! " + formatedResult
            );
            result++;
        }
    }

    return true;
}
