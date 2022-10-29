import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import PositionUtils;

module Component {
    typedef BoxProps as {
        :boxWidth as String?,
        :boxHeight as String?,
        :xPosition as String?,
        :yPosition as String?,
        :boxXShift as String?,
        :boxYShift as String?,
        :boxYShift as String?,
        :horizontalAlignment as PositionUtils.AlignmentEnum?,
        :verticalAlignment as PositionUtils.AlignmentEnum?,
        :font as Symbol?,
        :debug as Boolean?,
    };

    class Box extends BaseDrawable {
        private var DEBUG_LINE_SIZE = 2;
        private var _actualBoxSize as Dictionary or Null = null;
        private var _calculatedPosition as Dictionary or Null = null;
        
        protected var _font as WatchUi.Resource or Number;
        protected var _debug as Boolean;

        function initialize(params as BoxProps) {
            BaseDrawable.initialize(params);
            
            self._font = params.hasKey(:font) ? WatchUi.loadResource(params.get(:font)) : Graphics.FONT_MEDIUM;
            self._debug = params.hasKey(:debug) ? params.get(:debug) : false;

            self.calcActualBoxSize(params);
            self.calcPosition(params);
        }

        private function calcActualBoxSize(params as BoxProps) {
            var boxWidth = params.hasKey(:boxWidth) ? params.get(:boxWidth) : "0";
            var boxHeight = params.hasKey(:boxHeight) ? params.get(:boxHeight) : "0";

            self._actualBoxSize = {
                :width => self.parseActualSize(boxWidth, self.deviceWidth),
                :height => self.parseActualSize(boxHeight, self.deviceHeight)
            };
        }

        private function calcPosition(params as BoxProps) as {:x as Number, :y as Number} {
            self._calculatedPosition = {
                :x => self.calcHorizontalAlignment(params),
                :y => self.calcVerticalAlignment(params),
            };
        }

        protected function getActualBoxSize() as {:width as Number, :height as Number} {
            return self._actualBoxSize;
        }

        protected function getPosition() as {:x as Number, :y as Number} {
            return self._calculatedPosition;
        }

        protected function parseActualSize(position as String, size as Number) as Number {
            return PositionUtils.parsePosition(position, size);
        }

        private function calcXPoint(xPosition as String) as Number {
            return self.parseActualSize(xPosition, self.deviceWidth);
        }

        private function calcXShift(boxXShift as String) as Number {
            return self.parseActualSize(boxXShift, self.deviceWidth);
        }

        private function calcYPoint(yPosition as String) as Number {
            return self.parseActualSize(yPosition, self.deviceHeight);
        }

        private function calcYShift(boxYShift as String) as Number {
            return self.parseActualSize(boxYShift, self.deviceHeight);
        }

        private function calcHorizontalAlignment(params as BoxProps) as Number {
            var horizontalAlignment = params.hasKey(:horizontalAlignment) ? params.get(:horizontalAlignment) : PositionUtils.ALIGN_START;
            var xPosition = params.hasKey(:xPosition) ? params.get(:xPosition) : "0";
            var boxXShift = params.hasKey(:boxXShift) ? params.get(:boxXShift) : "0";

            var position = self.calcXPoint(xPosition);
            var shift = self.calcXShift(boxXShift);
            var boxSize = self.getActualBoxSize();

            return position - PositionUtils.calcAlignmentShift(horizontalAlignment, boxSize.get(:width)) + shift;
        }

        private function calcVerticalAlignment(params as BoxProps) as Number {
            var verticalAlignment = params.hasKey(:verticalAlignment) ? params.get(:verticalAlignment) : PositionUtils.ALIGN_START;
            var yPosition = params.hasKey(:yPosition) ? params.get(:yPosition) : "0";
            var boxYShift = params.hasKey(:boxYShift) ? params.get(:boxYShift) : "0";

            var position = self.calcYPoint(yPosition);
            var shift = self.calcYShift(boxYShift);
            var boxSize = self.getActualBoxSize();

            return position - PositionUtils.calcAlignmentShift(verticalAlignment, boxSize.get(:height)) + shift;
        }

        private function renderDebugArea(drawContext as Dc) {
            var position = self.getPosition();

            var posX = position.get(:x);
            var posY = position.get(:y);
            var boxSize = self.getActualBoxSize();

            var debugPosX = posX - self.DEBUG_LINE_SIZE;
            var debugPosY = posY - self.DEBUG_LINE_SIZE;
            var debugBoxWidth = boxSize.get(:width) + (self.DEBUG_LINE_SIZE * 2);
            var debugBoxHeight = boxSize.get(:height) + (self.DEBUG_LINE_SIZE * 2);

            drawContext.setClip(debugPosX, debugPosY, debugBoxWidth, debugBoxHeight);
            drawContext.setColor(
                Graphics.COLOR_RED,
                Graphics.COLOR_GREEN
            );
            drawContext.setPenWidth(self.DEBUG_LINE_SIZE);
            drawContext.fillRectangle(debugPosX, debugPosY, debugBoxWidth, debugBoxHeight);
        }

        private function clipRenderArea(drawContext as Dc) as Void {
            var position = self.getPosition();
            var boxSize = self.getActualBoxSize();

            var posX = position.get(:x);
            var posY = position.get(:y);

            drawContext.setClip(posX, posY, boxSize.get(:width), boxSize.get(:height));
        }

        protected function onRenderBefore(drawContext as Dc) {
            if (!self.isVisible) {
                return;
            }

            if(drawContext has :setAntiAlias) {
                drawContext.setAntiAlias(true);
            }

            self.clipRenderArea(drawContext);
        }

        protected function render(drawContext as Dc) {
            // Abstract
        }

        function draw(drawContext as Dc) as Void {
            self.onRenderBefore(drawContext);

            if (!self.isVisible) {
                return;
            }

            if (self._debug) {
                self.renderDebugArea(drawContext);
            }

            self.render(drawContext);
        }
    }
}