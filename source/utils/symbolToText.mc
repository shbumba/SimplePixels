import Toybox.Lang;
import Toybox.WatchUi;

function symbolToText(symbol as Symbol or Null) as String {
    return symbol != null ? WatchUi.loadResource(symbol) : "";
}

function symbolToTextOrNull(symbol as Symbol or Null) as String or Null {
    return symbol != null ? WatchUi.loadResource(symbol) : null;
}