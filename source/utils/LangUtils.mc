import Toybox.Lang;
import Toybox.Application;

(:background)
function isNotEmptyString(text) as Boolean {
    return text instanceof Lang.String && text.length() > 0;
}

function percentToAlpha(percent as Number) as Number {
    return ((percent.toFloat() / 100.0) * 255.0).toNumber();
}

(:background)
function combineDictionaries(
    d1 as Dictionary<PropertyKeyType, PropertyValueType>,
    d2 as Dictionary<PropertyKeyType, PropertyValueType>
) as Dictionary<PropertyKeyType, PropertyValueType> {
    var keys = d2.keys();

    for (var i = 0; i < keys.size(); i++) {
        var key = keys[i];
        d1[key] = d2[key];
    }

    return d1;
}
