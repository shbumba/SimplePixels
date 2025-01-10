import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import SettingsModule;

module SettingsMenuHelper {
    typedef MenuItemProps as {
        :label as ResourceId or String,
        :subLabel as ResourceId?,
        :identifier as Object or Number or String,
        :options as { :alignment as MenuItem.Alignment }?
    };

    typedef ToggleItemProps as {
        :label as ResourceId,
        :subLabel as ResourceId?,
        :identifier as Object or Number or String,
        :enabled as Boolean?,
        :options as { :alignment as MenuItem.Alignment }?
    };

    typedef MenuValueKey as SettingType.Enum;

    function setFocusOnMenuItem(menu as WatchUi.CustomMenu or WatchUi.Menu2, valueKey as MenuValueKey?) as Void {
        if (valueKey != null) {
            var settingValue = SettingsModule.getValue(valueKey);
            var valueItem = menu.findItemById(settingValue);

            menu.setFocus(valueItem);
        }
    }

    function BuildMenuItem(params as MenuItemProps) as WatchUi.MenuItem {
        return new WatchUi.MenuItem(
            params.get(:label),
            params.get(:subLabel),
            params.get(:identifier),
            params.get(:options)
        );
    }

    function BuildToggleMenuItem(params as ToggleItemProps) as WatchUi.ToggleMenuItem {
        var isEnabled = params.get(:enabled);
        var valueKey = params.get(:identifier);

        if (valueKey != null) {
            isEnabled = SettingsModule.getValue(valueKey as SettingType.Enum);
        }

        if (isEnabled == null) {
            isEnabled = false;
        }

        var label = WatchUi.loadResource(params.get(:label));
        var subLabel = params.get(:subLabel);
        subLabel = subLabel != null ? WatchUi.loadResource(subLabel) : null;

        return new WatchUi.ToggleMenuItem(label, subLabel, valueKey, isEnabled, params.get(:options));
    }
}
