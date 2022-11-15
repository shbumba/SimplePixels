import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

module Components {
    module ListItemsDerection {
        enum Enum {
            LEFT = 1,
            RIGHT
        }
    }

    typedef ItemType as {
        :text as String?,
        :icon as FontResource?,
        :icons as Array<FontResource>?
    };

    typedef ItemsRenderProps as {
        :items as Array<ItemType>,
        :drawContext as Dc,
        :derection as ListItemsDerection.Enum?
    };

    typedef ElementRenderProps as {
        :item as ItemType,
        :derection as ListItemsDerection.Enum?,
        :posX as Number,
        :posY as Number
    };

    typedef ListProps as BoxProps or
        {
        :itemHeight as String?,
        :iconSize as String?
    };

    class List extends Box {
        protected var _itemHeight as Number;
        protected var _iconSize as Number;

        function initialize(params as ListProps) {
            Box.initialize(params);

            var screenHeight = System.getDeviceSettings().screenHeight;

            var itemHeight = params.get(:itemHeight);
            self._itemHeight = itemHeight != null ? self.parseActualSize(itemHeight, screenHeight) : 10;

            var iconSize = params.get(:iconSize);
            self._iconSize = iconSize != null ? self.parseActualSize(iconSize, screenHeight) : 10;
        }

        private function setupItemHeight(drawContext as Dc) as Void {
            if (self._itemHeight != null) {
                return;
            }

            self._itemHeight = drawContext.getFontHeight(self.getFont()).toNumber();
        }

        private function getJustify(direction as ListItemsDerection.Enum) {
            if (direction == ListItemsDerection.LEFT) {
                return Graphics.TEXT_JUSTIFY_LEFT;
            }

            return Graphics.TEXT_JUSTIFY_RIGHT;
        }

        private function renderText(props as ElementRenderProps, drawContext as Dc) as Void {
            var item = props.get(:item);
            var text = item.get(:text);

            if (text == null || text == "") {
                return;
            }

            var posX = props.get(:posX);
            var textYPos = props.get(:posY);
            var textDerection = props.get(:direction);

            var textXPos = posX + self._iconSize;
            var textJustify = self.getJustify(textDerection);

            if (textDerection == ListItemsDerection.RIGHT) {
                textXPos = posX - self._iconSize;
            }

            drawContext.drawText(textXPos, textYPos, self.getFont(), text, textJustify);
        }

        private function renderIcon(props as ElementRenderProps, drawContext as Dc) as Void {
            var item = props.get(:item);
            var icon = item.get(:icon);

            if (icon == null) {
                return;
            }

            var posX = props.get(:posX);
            var posY = props.get(:posY);

            var iconDerection = props.get(:direction);
            var iconJustify = self.getJustify(iconDerection);

            drawContext.drawText(posX, posY, icon, $.ICON_SYMBOL, iconJustify);
        }

        private function renderIcons(props as ElementRenderProps, drawContext as Dc) as Void {
            var item = props.get(:item) as ItemType;
            var icons = item.get(:icons) as Array<FontResource>?;

            if (icons == null || icons.size() == 0) {
                return;
            }

            var posX = props.get(:posX);
            var posY = props.get(:posY);

            var iconDerection = props.get(:direction);
            var iconJustify = self.getJustify(iconDerection);

            for (var i = 0; i < icons.size(); i++) {
                var icon = icons[i];
                var offset = i * self._iconSize;
                var iconXPos = posX;

                if (offset > 0) {
                    switch (iconJustify) {
                        case Graphics.TEXT_JUSTIFY_LEFT:
                            iconXPos += offset;
                            break;

                        case Graphics.TEXT_JUSTIFY_RIGHT:
                            iconXPos -= offset;
                            break;
                    }
                }

                drawContext.drawText(iconXPos, posY, icon, $.ICON_SYMBOL, iconJustify);
            }
        }

        protected function renderItems(props as ItemsRenderProps) {
            var drawContext = props.get(:drawContext);
            var items = props.get(:items);
            var direction = props.get(:direction);
            var posX = self.getPosX();
            var posY = self.getPosY();
            direction = direction != null ? direction : ListItemsDerection.LEFT;

            if (direction == ListItemsDerection.RIGHT) {
                posX = posX + self.getWidth();
            }

            for (var i = 0; i < items.size(); i++) {
                var item = items[i];
                var itemYPos = i > 0 ? posY + self._itemHeight * i : posY;

                var renderProps = {
                    :item => item,
                    :direction => direction,
                    :posX => posX,
                    :posY => itemYPos
                };

                self.renderText(renderProps, drawContext);
                self.renderIcon(renderProps, drawContext);
                self.renderIcons(renderProps, drawContext);
            }
        }

        protected function onRenderBefore(drawContext as Dc) {
            Box.onRenderBefore(drawContext);
            self.setupItemHeight(drawContext);
        }
    }
}
