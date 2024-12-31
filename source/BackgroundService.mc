import Toybox.Lang;
import Toybox.Background;
import Toybox.System;
import Toybox.Time;
import Toybox.Position;
import Toybox.Communications;
import SettingsModule.SettingType;
import SettingsModule;
import StoreKeys;

(:background)
class BackgroundService extends System.ServiceDelegate {
    (:background)
    const _OW_URL = "https://api.openweathermap.org/data/2.5/weather";
    (:background)
    var _isRunning = false;

    function initialize() {
        System.ServiceDelegate.initialize();
    }

    (:background)
    function onTemporalEvent() as Void {
        if (self._isRunning) {
            return;
        }

        var apiKey = SettingsModule.getValue(SettingType.OW_API_KEY);

        if (!isNotEmptyString(apiKey)) {
            return;
        }

        var lat = SettingsModule.getValue(SettingType.OW_LAT);
        var lon = SettingsModule.getValue(SettingType.OW_LON);

        if (!isNotEmptyString(lat) || !isNotEmptyString(lon)) {
            var position = getLocation();

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

    (:background,:typecheck(false))
    function prepareWeatherData(data as Dictionary) as SensorsGetters.WeatherData {
        return {
            "time" => Time.now().value(),
            "max" => data["main"]["temp_max"],
            "min" => data["main"]["temp_min"],
            "current" => data["main"]["temp"],
            "feels" => data["main"]["feels_like"],
            "icon" => data["weather"][0]["id"]
        };
    }

    (:background)
    function onReceiveWeatherInfo(responseCode as Numeric, data as Dictionary or String or Null) as Void {
        self._isRunning = false;

        var result = {
            "hasError" => responseCode != 200
        };

        if (responseCode == 200 && data instanceof Dictionary) {
            var preparedData = prepareWeatherData(data);
            result = combineDictionaries(result, preparedData);
        }

        Background.exit({
            StoreKeys.OW_DATA => result as Dictionary
        });
    }

    (:background)
    function makeWebRequest(url as String, params as Dictionary, callback) as Void {
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
