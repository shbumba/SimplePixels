import Toybox.Lang;

module ColorsModule {
    module ColorsTypes {
        enum {
            BLACK = 1,
            WHITE,
            LIGHT_GRAY,
            GRAY,
            INDIGO,
            PURPLE,
            DEEP_PURPLE,
            PINK,
            BLUE_GREY,
            BLUE,
            LIGHT_BLUE,
            TEAL,
            OCEAN_BLUE,
            LIME,
            GREEN,
            DARK_GREEN,
            LIGHT_GREEN,
            YELLOW,
            AMBER,
            ORANGE,
            DEEP_ORANGE,
            RED,
            DARK_RED,
            BROWN,
            LIGHT_BROWN
        }
    }

    typedef ColorsDictionaryItem as Array; // [color as Hex, title as Symbol]

    var ColorsDictionary as Dictionary<ColorsTypes, ColorsDictionaryItem> = {
        ColorsTypes.BLACK => [0x000000, Rez.Strings.ColorBlack],
        ColorsTypes.WHITE => [0xffffff, Rez.Strings.ColorWhite],
        ColorsTypes.LIGHT_GRAY => [0xaaaaaa, Rez.Strings.ColorLightGray],
        ColorsTypes.GRAY => [0x555555, Rez.Strings.ColorGrey],
        ColorsTypes.INDIGO => [0x5500aa, Rez.Strings.ColorIndigo],
        ColorsTypes.PURPLE => [0xaa00ff, Rez.Strings.ColorPurple],
        ColorsTypes.DEEP_PURPLE => [0xff0055, Rez.Strings.ColorDeepPurple],
        ColorsTypes.PINK => [0xffc0cb, Rez.Strings.ColorPink],
        ColorsTypes.BLUE_GREY => [0x5555aa, Rez.Strings.ColorBlueGrey],
        ColorsTypes.BLUE => [0x0055aa, Rez.Strings.ColorBlue],
        ColorsTypes.LIGHT_BLUE => [0x00aaff, Rez.Strings.ColorLightBlue],
        ColorsTypes.TEAL => [0x00ffff, Rez.Strings.ColorTeal],
        ColorsTypes.OCEAN_BLUE => [0x005eb8, Rez.Strings.ColorOceanBlue],
        ColorsTypes.LIME => [0xaaff55, Rez.Strings.ColorLime],
        ColorsTypes.GREEN => [0x00ff00, Rez.Strings.ColorGreen],
        ColorsTypes.DARK_GREEN => [0x005500, Rez.Strings.ColorDarkGreen],
        ColorsTypes.LIGHT_GREEN => [0x00ffaa, Rez.Strings.ColorLightGreen],
        ColorsTypes.YELLOW => [0xffff55, Rez.Strings.ColorYellow],
        ColorsTypes.AMBER => [0xffaa00, Rez.Strings.ColorAmber],
        ColorsTypes.ORANGE => [0xff5500, Rez.Strings.ColorOrange],
        ColorsTypes.DEEP_ORANGE => [0xdd6e0f, Rez.Strings.ColorDeepOrange],
        ColorsTypes.RED => [0xff0000, Rez.Strings.ColorRed],
        ColorsTypes.DARK_RED => [0xaa0005, Rez.Strings.ColorDarkRed],
        ColorsTypes.BROWN => [0x550000, Rez.Strings.ColorBrown],
        ColorsTypes.LIGHT_BROWN => [0xaa5500, Rez.Strings.ColorLightBrown]
    };

    function getColorItem(key as ColorsTypes) as Number {
        return ColorsDictionary.get(key);
    }

    function getColor(key as ColorsTypes) as Number {
        return getColorItem(key)[0];
    }

    function getColorName(key as ColorsTypes) as Symbol {
        return getColorItem(key)[1];
    }
}
