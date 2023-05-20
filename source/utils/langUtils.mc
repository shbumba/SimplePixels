import Toybox.Lang;

function clearDictionary(disctionary as Dictionary) as Void {
    var keys = disctionary.keys();

    while (keys.size() > 0) {
        disctionary.remove(keys[0]);
        keys.remove(keys[0]);
    }
}