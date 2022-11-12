import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import PositionUtils;

module Component {
    typedef BoxProps as {
        :boxWidth as String?,
        :boxHeight as String?,
        :xPos as String?,
        :yPos as String?,
        :xShift as String?,
        :yShift as String?,
        :horizontalAlignment as PositionUtils.AlignmentEnum?,
        :verticalAlignment as PositionUtils.AlignmentEnum?,
        :font as Symbol?,
        :debug as Boolean?,
    };

    typedef ActualBoxSize as {:width as Number, :height as Number};
    typedef CalculatedPosition as {:x as Number, :y as Number};

    class Box extends BaseDrawable {
        private var DEBUG_LINE_SIZE = 2;
        private var _actualBoxSize as ActualBoxSize or Null = null;
        private var _calculatedPosition as CalculatedPosition or Null = null;
        private var _font as Symbol or Null;
        
        protected var _debug as Boolean;

        function initialize(params as BoxProps) {
            BaseDrawable.initialize(params);
            
            var font = params.get(:font);
            self._font = font != null ? font : null;

            var debug = params.get(:debug);
            self._debug = debug != null ? debug : false;

            self.calcActualBoxSize(params);
            self.calcPosition(params);
        }

        private function calcActualBoxSize(params as BoxProps) {
            var deviceSettings = System.getDeviceSettings();
            var boxWidth = params.get(:boxWidth);
            boxWidth = boxWidth != null ? boxWidth : "0";

            var boxHeight = params.get(:boxHeight);
            boxHeight = boxHeight != null ? boxHeight : "0";

            self._actualBoxSize = {
                :width => self.parseActualSize(boxWidth, deviceSettings.screenWidth),
                :height => self.parseActualSize(boxHeight, deviceSettings.screenHeight)
            };
        }

        private function calcPosition(params as BoxProps) as Void {
            self._calculatedPosition = {
                :x => self.calcHorizontalAlignment(params),
                :y => self.calcVerticalAlignment(params),
            };
        }

        protected function getFont() as Resource or Number {
            return self._font != null ? ResourcesCache.get(self._font) : Graphics.FONT_MEDIUM;
        }

        protected function getActualBoxSize() as ActualBoxSize {
            return self._actualBoxSize;
        }

        protected function getPosition() as CalculatedPosition {
            return self._calculatedPosition;
        }

        protected function parseActualSize(position as String, size as Number) as Number {
            return PositionUtils.parsePosition(position, size);
        }

        private function calcXPoint(xPos as String) as Number {
            var deviceWidth = System.getDeviceSettings().screenWidth;

            return self.parseActualSize(xPos, deviceWidth);
        }

        private function calcXShift(xShift as String) as Number {
            var deviceWidth = System.getDeviceSettings().screenWidth;

            return self.parseActualSize(xShift, deviceWidth);
        }

        private function calcYPoint(yPos as String) as Number {
            var screenHeight = System.getDeviceSettings().screenHeight;
            
            return self.parseActualSize(yPos, screenHeight);
        }

        private function calcYShift(yShift as String) as Number {
            var screenHeight = System.getDeviceSettings().screenHeight;

            return self.parseActualSize(yShift, screenHeight);
        }

        private function calcHorizontalAlignment(params as BoxProps) as Number {
            var horizontalAlignment = params.get(:horizontalAlignment);
            horizontalAlignment = horizontalAlignment ? horizontalAlignment : PositionUtils.ALIGN_START;

            var xPos = params.get(:xPos);
            xPos = xPos != null ? xPos : "0";

            var xShift = params.get(:xShift);
            xShift = xShift != null ? xShift : "0";

            var position = self.calcXPoint(xPos);
            var shift = self.calcXShift(xShift);
            var boxSize = self.getActualBoxSize();

            return position - PositionUtils.calcAlignmentShift(horizontalAlignment, boxSize.get(:width)) + shift;
        }

        private function calcVerticalAlignment(params as BoxProps) as Number {
            var verticalAlignment = params.get(:verticalAlignment);
            verticalAlignment = verticalAlignment ? verticalAlignment : PositionUtils.ALIGN_START;

            var yPos = params.get(:yPos);
            yPos = yPos != null ? yPos : "0";

            var yShift = params.get(:yShift);
            yShift = yShift != null ? yShift : "0";

            var position = self.calcYPoint(yPos);
            var shift = self.calcYShift(yShift);
            var boxSize = self.getActualBoxSize();

            return position - PositionUtils.calcAlignmentShift(verticalAlignment, boxSize.get(:height)) + shift;
        }

        (:debug)
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

        (:debug)
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

        (:release)
        function draw(drawContext as Dc) as Void {
            self.onRenderBefore(drawContext);

            if (!self.isVisible) {
                return;
            }

            self.render(drawContext);
        }
    }
}