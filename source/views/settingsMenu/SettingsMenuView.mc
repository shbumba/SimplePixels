import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

class SettingsMenuView extends WatchUi.View {
    private var onSettingsChanged as Method or Null;

    function initialize(onSettingsChanged as Method) {
        View.initialize();

        self.onSettingsChanged = onSettingsChanged;
    }

    function onLayout(drawContext as Dc) {
        var onBack = new Lang.Method(self, :onBack);

        WatchUi.switchToView(SettingsMenu(), new SettingsMenuBehaviour(onBack), WatchUi.SLIDE_IMMEDIATE);
    }

    function onUpdate(drawContext as Dc) as Void {
        drawContext.clearClip();
    }

    function onBack() as Void {
        self.onSettingsChanged.invoke();
        self.onSettingsChanged = null;
    }
}