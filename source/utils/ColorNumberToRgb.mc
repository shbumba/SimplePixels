import Toybox.Lang;

function colorNumberToRgb(color as Numeric) as [Number, Number, Number] {
    var hexString = color.format("%X"); 
    var hex = hexString.toNumberWithBase(16);

    var r = (hex >> 16) & 0xFF;
    var g = (hex >> 8) & 0xFF;
    var b = hex & 0xFF;

    return [r, g, b];
}