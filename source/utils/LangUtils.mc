import Toybox.Lang;

(:background)
function isNotEmptyString(text) as Boolean {
    return (text instanceof Lang.String) && (text.length() > 0);
}