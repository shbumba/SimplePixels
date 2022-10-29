import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

module Component {
    const ListItemsDerection = {
        :left => "left",
        :rigth => "right"
    };

    typedef ItemType as {
        :text as String?,
        :icon as String?,
    };

    typedef ItemsRenderProps as {
        :items as Array<ItemType>,
        :posX as Number,
        :posY as Number,
        :drawContext as Dc,
        :derection as String? // @type: ListItemsDerection
    };

    typedef ElementRenderProps as {
        :item as ItemType,
        :derection as String?, // @type: ListItemsDerection
        :posX as Number,
        :posY as Number,
    };

    class List extends Box {
        protected var _itemHeight as String or Null = null;
        protected var _iconFont;
        protected var _iconSize as Number;

        function initialize(params as Dictionary<String, String?>) {
            Box.initialize(params);

            self._itemHeight = params.hasKey(:itemHeight) ? self.parseActualSize(params.get(:itemHeight), self.deviceHeight) : 10;
            self._iconSize = params.hasKey(:iconSize) ? self.parseActualSize(params.get(:iconSize), self.deviceHeight) : 10;
            self._iconFont = params.hasKey(:iconFont) ? WatchUi.loadResource(params.get(:iconFont)) : null;
        }

        private function setupItemHeight(drawContext as Dc) as Void {
            if (self._itemHeight != null) {
                return;
            }

            self._itemHeight = drawContext.getFontHeight(self._font).toString();
        }

        private function getJustify(direction) {
            if (direction == ListItemsDerection.get(:left)) {
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

            if (textDerection == ListItemsDerection.get(:right)) {
                textXPos = posX - self._iconSize;
            }

            drawContext.drawText(textXPos, textYPos, self._font, text, textJustify);
        }

        private function renderIcon(props as ElementRenderProps, drawContext as Dc) as Void {
            var item = props.get(:item);
            var icon = item.get(:icon);

            if (self._iconFont == null || icon == null || icon == "") {
                return;
            }

            var posX = props.get(:posX);
            var posY = props.get(:posY);

            var iconDerection = props.get(:direction);
            var iconJustify = self.getJustify(iconDerection);

            drawContext.drawText(posX, posY, self._iconFont, icon, iconJustify);
        }

        protected function renderItems(props as ItemsRenderProps) {
            var boxSize = self.getActualBoxSize();
            var drawContext = props.get(:drawContext);
            var items = props.get(:items);
            var posX = props.get(:posX);
            var posY = props.get(:posY);
            var direction = props.hasKey(:direction) ? props.get(:direction) : ListItemsDerection.get(:left);

            if (direction == ListItemsDerection.get(:right)) {
                posX = posX + boxSize.get(:width);
            }

            for (var i = 0; i < items.size(); i++) {
                var item = items[i];
                var itemYPos = i > 0 ? posY + (self._itemHeight * i) : posY;

                var renderProps = {
                    :item => item,
                    :direction => direction,
                    :posX => posX,
                    :posY => itemYPos,
                };

                self.renderText(renderProps, drawContext);
                self.renderIcon(renderProps, drawContext);
            }
        }

        protected function onRenderBefore(drawContext as Dc) {
            Box.onRenderBefore(drawContext);
            self.setupItemHeight(drawContext);
        }
    }
}