const VIEWS_LIST = {
    :background => "Background",
    :prevHours => "PrevHours",
    :date => "Date",
    :hours => "Hours",
    :nextHours => "NextHours",
    :infoBar => "InfoBar",
    :minutes => "Minutes",
    :pm => "PM",
    :seconds => "Seconds",
    :leftSensors => "LeftSensors",
    :topSensors => "TopSensors",
    :bottomSensors => "BottomSensors",
};

const ICON_SYMBOL = " ";
const IS_LOW_MEMORY = Toybox.System.getSystemStats().totalMemory < 95000;