import Toybox.Lang;
import Toybox.Application;

(:debug,:background)
function debug(text as String, data as Dictionary<PropertyKeyType, PropertyValueType>?) as Void {
    var output = text;

    if (data != null) {
        output += "::( ";

        var keys = data.keys();

        for (var i = 0; i < keys.size(); i++) {
            if (i > 0) {
                output += " -> ";
            }

            var key = keys[i];
            var val = data[key];

            output += key.toString() + ": " + val.toString();
        }

        output += " )";
    }

    Toybox.System.println(output);
}