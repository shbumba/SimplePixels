import Toybox.Lang;
import Toybox.Background;
import Toybox.Activity;
import Toybox.Weather;
import Toybox.Position;

(:background)
function isValidCoordinates(coords as [Lang.Double or Lang.Float, Lang.Double or Lang.Float]) as Boolean {
    if (coords.size() != 2) {
        return false;
    }

    var latitude = coords[0];
    var longitude = coords[1];

    if (!(latitude instanceof Lang.Double || latitude instanceof Lang.Float) || !(longitude instanceof Lang.Double || longitude instanceof Lang.Float)) {
        return false;
    }

    if (latitude < -90.0 || latitude > 90.0) {
        return false;
    }

    if (longitude < -180.0 || longitude > 180.0) {
        return false;
    }

    return true;
}

(:background)
function isValidLocation(location as Position.Location?) as Boolean {
    if (location == null) {
        return false;
    }

    return isValidCoordinates(location.toDegrees());
}

(:background)
function getLastLocation() as Position.Location? {
    var activityInfo = Activity.getActivityInfo();

    if (activityInfo != null && activityInfo has :currentLocation) {
        return isValidLocation(activityInfo.currentLocation) ? activityInfo.currentLocation : null;
    }

    return null;
}

(:background)
function getCurrentLocation() as Position.Location? {
    var positionInfo = Position.getInfo();

    if (positionInfo has :position) {
        return isValidLocation(positionInfo.position) ? positionInfo.position : null;
    }

    return null;
}

(:background)
function getWeatherLocation() as Position.Location? {
    var weatherInfo = Weather.getCurrentConditions();

    if (weatherInfo != null && weatherInfo has :observationLocationPosition) {
        return isValidLocation(weatherInfo.observationLocationPosition)
            ? weatherInfo.observationLocationPosition
            : null;
    }

    return null;
}

(:background)
function getLocation() as Position.Location? {
    var location = getCurrentLocation();
    location = location == null ? getLastLocation() : location;
    location = location == null ? getWeatherLocation() : location;

    return location;
}
