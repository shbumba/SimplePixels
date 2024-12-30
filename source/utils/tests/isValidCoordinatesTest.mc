import Toybox.Lang;
import Toybox.Time;
import Toybox.Test;

(:test)
function isValidCoordinatesTest(logger as Test.Logger) as Boolean {
    var coords = [
        [45.0, 90.0],
        [90.0, 180.0],
        [-90.0, -180.0],
        [180.0, 180.0],
        [91.0, 45.0],
        [-91.0, 45.0],
        [45.0, 181.0],
        [45.0, -181.0],
        [45.0],
        ["45.0", 90.0],
        [45.0, null],
    ] as Array<Object>;

    var expectResults = [true, true, true, false, false, false, false, false, false, false, false];

    for (var i = 0; i < coords.size(); i++) {
        var currentCoord = coords[i];
        var isValid = isValidCoordinates(currentCoord);
        var expectResult = expectResults[i];

        Test.assertEqualMessage(
            expectResult,
            isValid,
            "indexResult: [" + i + "] is not equal! "
        );
    }

    return true;
}
