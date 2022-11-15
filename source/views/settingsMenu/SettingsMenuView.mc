import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;
import SettingsModule.SettingType;

class SettingsMenuView extends WatchUi.View {
    private var onSettingsChanged as Method?;

    function initialize(onSettingsChanged as Method) {
        View.initialize();

        self.onSettingsChanged = onSettingsChanged;
    }

    function onLayout(drawContext as Dc) as Void {
        RenderSettingsMenu(self.method(:onBack), WatchUi.SLIDE_IMMEDIATE, null);
    }

    function onUpdate(drawContext as Dc) as Void {
        drawContext.clearClip();
    }

    function onBack() as Void {
        self.onSettingsChanged.invoke();
        self.onSettingsChanged = null;
    }
}
