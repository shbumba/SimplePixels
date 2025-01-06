import Toybox.Lang;
import Toybox.Math;

function blendColors(fgColor as Numeric, bgColor as Numeric, opacity as Numeric) as Numeric {
    var normalizedOpacity = opacity.toFloat() / 100.0;
    
    var fgRGB = colorNumberToRgb(fgColor);
    var bgRGB = colorNumberToRgb(bgColor);

    var newRGB = [] as [Numeric, Numeric, Numeric];

    for (var i = 0; i < 3; i++) {
        var mixedColor = Math.round(((fgRGB[i] * (1.0 - normalizedOpacity)) + (bgRGB[i] * normalizedOpacity)).toNumber());
        newRGB.add(clamp(mixedColor, 0, 255));
    }

    return (newRGB[0] << 16) | (newRGB[1] << 8) | newRGB[2];
}