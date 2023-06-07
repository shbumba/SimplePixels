import Toybox.Lang;
import Toybox.Background;
import Toybox.System;
import Toybox.Time;
import Toybox.Position;
import Toybox.Communications;
import SettingsModule.SettingType;
import SettingsModule;

(:background)
class BackgroundService extends System.ServiceDelegate {
    const _OW_URL = "https://api.openweathermap.org/data/2.5/weather";
    (:background)
    var _isRunning = false;

    function initialize() {
        System.ServiceDelegate.initialize();
    }

    function onTemporalEvent() as Void {
        if (self._isRunning) {
            return;
        }

        var apiKey = SettingsModule.getValue(SettingType.OPENWEATHER_API_KEY);

        if (!isNotEmptyString(apiKey)) {
            return;
        }

        var lat = SettingsModule.getValue(SettingType.OPENWEATHER_LAT);
        var lon = SettingsModule.getValue(SettingType.OPENWEATHER_LON);

        if (!isNotEmptyString(lat) || !isNotEmptyString(lon)) {
            var position = self.getCurrentLocation();

            if (position == null) {
                return;
            }

            var degrees = position.toDegrees();

            lat = degrees[0].toString();
            lon = degrees[1].toString();
        }

        self.getWeatherInfo(apiKey, lat, lon);
    }

    (:background)
    function getCurrentLocation() as Position.Location? {
        var positionInfo = Position.getInfo();

        if (positionInfo has :position && positionInfo.position != null) {
            return positionInfo.position as Position.Location;
        }

        return null;
    }

    (:background)
    function getWeatherInfo(apiKey as String, lat as String, lon as String) as Void {
        self._isRunning = true;

        self.makeWebRequest(
            self._OW_URL,
            {
                "appid" => apiKey,
                "lat" => lat,
                "lon" => lon,
                "units" => "metric"
            },
            method(:onReceiveWeatherInfo)
        );
    }

    (:background)
    function onReceiveWeatherInfo(responseCode as Numeric, data) as Void {
        self._isRunning = false;

        var result = {
            "httpError" => responseCode
        };

        if (responseCode == 200) {
            result = {
                "time" => Time.now().value(),
                "max" => data["main"]["temp_max"],
                "min" => data["main"]["temp_min"],
                "current" => data["main"]["temp"],
                "feels" => data["main"]["feels_like"]
            };
        }

        Background.exit({
            "OpenWeatherData" => result as Dictionary
        });
    }

    (:background)
    function makeWebRequest(url, params, callback) as Void {
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        Communications.makeWebRequest(url, params, options, callback);
    }
}
