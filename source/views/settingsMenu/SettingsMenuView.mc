import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

class SettingsMenuView extends WatchUi.View {
    var _onSettingsChanged as Method?;

    function initialize(onSettingsChanged as Method) {
        View.initialize();

        self._onSettingsChanged = onSettingsChanged;
    }

    function onLayout(drawContext as Dc) as Void {
        RenderSettingsMenu(self.method(:onBack), WatchUi.SLIDE_IMMEDIATE, null);
    }

    function onUpdate(drawContext as Dc) as Void {
        drawContext.clearClip();
    }

    function onBack() as Void {
        self._onSettingsChanged.invoke();
        self._onSettingsChanged = null;
    }
}
