import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import SettingsModule;

module WatchSettingsMenuBuilder {
    typedef MenuProps as { :title as String or Symbol or WatchUi.Drawable, :focus as Number? };

    typedef CustomMenuProps as {
            :itemHeight as Number,
            :backgroundColor as Graphics.ColorType,
            :options as
                {
                    :focus as Number,
                    :focusItemHeight as Number?,
                    :title as WatchUi.Drawable,
                    :footer as WatchUi.Drawable,
                    :foreground as WatchUi.Drawable,
                    :titleItemHeight as Number?,
                    :footerItemHeight as Number?
                }?
        };

    typedef MenuItemProps as {
            :label as String or Symbol,
            :subLabel as String or Symbol or Null,
            :identifier as Object,
            :options as { :alignment as MenuItem.Alignment }?
        };

    typedef ToggleItemProps as {
            :label as String,
            :subLabel as String or { :enabled as String, :disabled as String } or Null,
            :identifier as Object,
            :enabled as Boolean?,
            :options as { :alignment as MenuItem.Alignment }?
        };

    typedef MenuValueKey as String or Number;

    typedef GenerateItemProps as {
            :buider as ItemBuilders.ItemBuilder,
            :buiderProps as MenuItemProps or CustomColorMenuItemProps or ToggleItemProps,
            :valueKey as MenuValueKey?
        };

    typedef GenerateMenuProps as {
            :buider as MenuBuilders.MenuBuilder,
            :buiderProps as MenuProps or CustomMenuProps,
            :valueKey as MenuValueKey?,
            :items as Array<GenerateItemProps>
        };

    module MenuBuilders {
        enum MenuBuilder {
            MENU = 1,
            CUSTOM_MENU
        }

        var buidersMap = {
            MENU => :BuildMenu,
            CUSTOM_MENU => :BuildCustomMenu,
        };

        function BuildMenu(params as MenuProps) as WatchUi.Menu2 {
            return new WatchUi.Menu2(params);
        }

        function BuildCustomMenu(params as CustomMenuProps) as WatchUi.CustomMenu {
            return new WatchUi.CustomMenu(params.get(:itemHeight), params.get(:backgroundColor), params.get(:options));
        }
    }

    module ItemBuilders {
        enum ItemBuilder {
            ITEM = 1,
            CUSTOM_COLOR_ITEM,
            CUSTOM_ICON_ITEM,
            TOGGLE_ITEM
        }

        var buidersMap = {
            ITEM => :BuildMenuItem,
            CUSTOM_COLOR_ITEM => :BuildCustomColorMenuItem,
            CUSTOM_ICON_ITEM => :BuildCustomIconMenuItem,
            TOGGLE_ITEM => :BuildToggleMenuItem
        };

        function BuildMenuItem(params as MenuItemProps, valueKey as MenuValueKey?) as WatchUi.MenuItem {
            return new WatchUi.MenuItem(
                params.get(:label),
                params.get(:subLabel),
                params.get(:identifier),
                params.get(:options)
            );
        }

        function BuildCustomColorMenuItem(
            params as CustomColorMenuItemProps,
            valueKey as MenuValueKey?
        ) as CustomColorMenuItem {
            return new CustomColorMenuItem(params);
        }

        function BuildCustomIconMenuItem(
            params as CustomIconMenuItemProps,
            valueKey as MenuValueKey?
        ) as CustomIconMenuItem {
            return new CustomIconMenuItem(params);
        }

        function BuildToggleMenuItem(
            params as ToggleItemProps,
            valueKey as MenuValueKey?
        ) as WatchUi.ToggleMenuItem {
            var isEnabled = params.get(:enabled);

            if (valueKey) {
                isEnabled = SettingsModule.getValue(valueKey);
            }

            if (isEnabled == null) {
                isEnabled = false;
            }

            return new WatchUi.ToggleMenuItem(
                params.get(:label),
                params.get(:subLabel),
                params.get(:identifier),
                isEnabled,
                params.get(:options)
            );
        }
    }

    function generateMenuItem(props as GenerateItemProps) as WatchUi.MenuItem or WatchUi.CustomMenuItem {
        var itemBuilder = props.get(:buider);

        if (itemBuilder == null) {
            throw new Toybox.Lang.InvalidValueException("the item buider prop is required");
        }

        itemBuilder = ItemBuilders.buidersMap.get(itemBuilder);

        if (itemBuilder == null) {
            throw new Toybox.Lang.InvalidValueException("the item buider prop has an incorrect value");
        }
        
        var method = new Lang.Method(ItemBuilders, itemBuilder);
        var item = method.invoke(props.get(:buiderProps), props.get(:valueKey));

        return item;
    }

    function generateMenu(props as GenerateMenuProps) as WatchUi.Menu2 or WatchUi.CustomMenu {
        var menuBuilder = props.get(:buider);

        if (menuBuilder == null) {
            throw new Toybox.Lang.InvalidValueException("the menu buider prop is required");
        }

        menuBuilder = MenuBuilders.buidersMap.get(menuBuilder);

        if (menuBuilder == null) {
            throw new Toybox.Lang.InvalidValueException("the menu buider prop has an incorrect value");
        }

        var valueKey = props.get(:valueKey);
        var method = new Lang.Method(MenuBuilders, menuBuilder);
        var methodProps = props.get(:buiderProps);
        var menu = method.invoke(methodProps);
        var items = props.get(:items);

        for (var i = 0; i < items.size(); i++) {
            var item = items[i];

            menu.addItem(generateMenuItem(item));
        }

        if (valueKey) {
            var settingValue = SettingsModule.getValue(valueKey);
            var valueItem = menu.findItemById(settingValue);

            menu.setFocus(valueItem);
        }

        return menu;
    }
}