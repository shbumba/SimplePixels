import Toybox.Lang;

function colorNumberToRgb(color as Numeric) as [Number, Number, Number] {
    var hexString = color.format("%X"); 
    var hex = hexString.toNumberWithBase(16);

    var r = (hex >> 16) & 255;
    var g = (hex >> 8) & 255;
    var b = hex & 255;

    return [r, g, b];
}