import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import PositionUtils;
import ResourcesCache;

module Components {
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
        :debug as Boolean?
    };

    class Box extends BaseDrawable {
        private var DEBUG_LINE_SIZE = 2;
        private var _font as Symbol?;
        private var _boxWidth as Number? = null;
        private var _boxHeight as Number? = null;
        private var _posY as Number? = null;
        private var _posX as Number? = null;

        protected var _debug as Boolean;

        function initialize(params as BoxProps) {
            self.calcActualBoxSize(params);
            self.calcPosition(params);

            BaseDrawable.initialize(params);

            var font = params.get(:font);
            self._font = font != null ? font : null;

            var debug = params.get(:debug);
            self._debug = debug != null ? debug : false;
        }

        private function calcActualBoxSize(params as BoxProps) {
            var deviceSettings = System.getDeviceSettings();
            var boxWidth = params.get(:boxWidth);
            boxWidth = boxWidth != null ? boxWidth : "0";

            var boxHeight = params.get(:boxHeight);
            boxHeight = boxHeight != null ? boxHeight : "0";

            self._boxWidth = self.parseActualSize(boxWidth, deviceSettings.screenWidth);
            self._boxHeight = self.parseActualSize(boxHeight, deviceSettings.screenHeight);
        }

        private function calcPosition(params as BoxProps) as Void {
            self._posX = self.calcHorizontalAlignment(params);
            self._posY = self.calcVerticalAlignment(params);
        }

        protected function getFont() as Resource or Number {
            return self._font != null ? ResourcesCache.get(self._font) : Graphics.FONT_MEDIUM;
        }

        protected function getWidth() as Number {
            return self._boxWidth as Number;
        }

        protected function getHeight() as Number {
            return self._boxHeight as Number;
        }

        protected function getPosX() as Number {
            return self._posX as Number;
        }

        protected function getPosY() as Number {
            return self._posY as Number;
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
            var width = self.getWidth();

            return position - PositionUtils.calcAlignmentShift(horizontalAlignment, width) + shift;
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
            var height = self.getHeight();

            return position - PositionUtils.calcAlignmentShift(verticalAlignment, height) + shift;
        }

        (:debug)
        private function renderDebugArea(drawContext as Dc) {
            var debugPosX = self.getPosX() - self.DEBUG_LINE_SIZE;
            var debugPosY = self.getPosY() - self.DEBUG_LINE_SIZE;
            var debugBoxWidth = self.getWidth() + self.DEBUG_LINE_SIZE * 2;
            var debugBoxHeight = self.getHeight() + self.DEBUG_LINE_SIZE * 2;

            drawContext.setClip(debugPosX, debugPosY, debugBoxWidth, debugBoxHeight);
            drawContext.setColor(Graphics.COLOR_RED, Graphics.COLOR_GREEN);
            drawContext.setPenWidth(self.DEBUG_LINE_SIZE);
            drawContext.fillRectangle(debugPosX, debugPosY, debugBoxWidth, debugBoxHeight);
        }

        private function clipRenderArea(drawContext as Dc) as Void {
            drawContext.setClip(self.getPosX(), self.getPosY(), self.getWidth(), self.getHeight());
        }

        protected function onRenderBefore(drawContext as Dc) {
            if (!self.isVisible) {
                return;
            }

            if (drawContext has :setAntiAlias) {
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
