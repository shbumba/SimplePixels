import Toybox.Lang;

(:background)
function isNotEmptyString(text) as Boolean {
    return (text instanceof Lang.String) && (text.length() > 0);
}

function percentToAlpha(percent as Number) as Number {
    return ((percent.toFloat() / 100.0) * 255.0).toNumber();
}