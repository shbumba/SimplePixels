import Toybox.Lang;

module ColorsModule {
    module ColorsTypes {
        enum Enum {
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

    var ColorsMap = {
        ColorsTypes.BLACK => 0x000000,
        ColorsTypes.WHITE => 0xffffff,
        ColorsTypes.LIGHT_GRAY => 0xaaaaaa,
        ColorsTypes.GRAY => 0x555555,
        ColorsTypes.INDIGO => 0x5500aa,
        ColorsTypes.PURPLE => 0xaa00ff,
        ColorsTypes.DEEP_PURPLE => 0xff0055,
        ColorsTypes.PINK => 0xffc0cb,
        ColorsTypes.BLUE_GREY => 0x5555aa,
        ColorsTypes.BLUE => 0x0055aa,
        ColorsTypes.LIGHT_BLUE => 0x00aaff,
        ColorsTypes.TEAL => 0x00ffff,
        ColorsTypes.OCEAN_BLUE => 0x005eb8,
        ColorsTypes.LIME => 0xaaff55,
        ColorsTypes.GREEN => 0x00ff00,
        ColorsTypes.DARK_GREEN => 0x005500,
        ColorsTypes.LIGHT_GREEN => 0x00ffaa,
        ColorsTypes.YELLOW => 0xffff55,
        ColorsTypes.AMBER => 0xffaa00,
        ColorsTypes.ORANGE => 0xff5500,
        ColorsTypes.DEEP_ORANGE => 0xdd6e0f,
        ColorsTypes.RED => 0xff0000,
        ColorsTypes.DARK_RED => 0xaa0005,
        ColorsTypes.BROWN => 0x550000,
        ColorsTypes.LIGHT_BROWN => 0xaa5500
    } as Dictionary<ColorsTypes.Enum, Number>;

    var TextsMap = {
        ColorsTypes.BLACK => Rez.Strings.ColorBlack,
        ColorsTypes.WHITE => Rez.Strings.ColorWhite,
        ColorsTypes.LIGHT_GRAY => Rez.Strings.ColorLightGray,
        ColorsTypes.GRAY => Rez.Strings.ColorGrey,
        ColorsTypes.INDIGO => Rez.Strings.ColorIndigo,
        ColorsTypes.PURPLE => Rez.Strings.ColorPurple,
        ColorsTypes.DEEP_PURPLE => Rez.Strings.ColorDeepPurple,
        ColorsTypes.PINK => Rez.Strings.ColorPink,
        ColorsTypes.BLUE_GREY => Rez.Strings.ColorBlueGrey,
        ColorsTypes.BLUE => Rez.Strings.ColorBlue,
        ColorsTypes.LIGHT_BLUE => Rez.Strings.ColorLightBlue,
        ColorsTypes.TEAL => Rez.Strings.ColorTeal,
        ColorsTypes.OCEAN_BLUE => Rez.Strings.ColorOceanBlue,
        ColorsTypes.LIME => Rez.Strings.ColorLime,
        ColorsTypes.GREEN => Rez.Strings.ColorGreen,
        ColorsTypes.DARK_GREEN => Rez.Strings.ColorDarkGreen,
        ColorsTypes.LIGHT_GREEN => Rez.Strings.ColorLightGreen,
        ColorsTypes.YELLOW => Rez.Strings.ColorYellow,
        ColorsTypes.AMBER => Rez.Strings.ColorAmber,
        ColorsTypes.ORANGE => Rez.Strings.ColorOrange,
        ColorsTypes.DEEP_ORANGE => Rez.Strings.ColorDeepOrange,
        ColorsTypes.RED => Rez.Strings.ColorRed,
        ColorsTypes.DARK_RED => Rez.Strings.ColorDarkRed,
        ColorsTypes.BROWN => Rez.Strings.ColorBrown,
        ColorsTypes.LIGHT_BROWN => Rez.Strings.ColorLightBrown
    } as Dictionary<ColorsTypes.Enum, Symbol>;

    function getColor(key as ColorsTypes.Enum) as Number {
        return ColorsMap.get(key) as Number;
    }

    function getColorName(key as ColorsTypes.Enum) as Symbol {
        return TextsMap.get(key) as Symbol;
    }
}
