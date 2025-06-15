import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import TimeStackModule;
import GlobalKeys;

module Components {
    module TimeViewType {
        enum TimeViewTypeEnum {
            HOURS = 1,
            MINUTES = 2
        }
    }

    typedef TimeViewProps as BoxProps or
        {
        :type as TimeViewType.TimeViewTypeEnum?,
        :textAlignment as Graphics.TextJustification?
    };

    class TimeView extends Box {
        protected var _timeType as TimeViewType.TimeViewTypeEnum;
        protected var _textAlignment as Graphics.TextJustification;
        private var _aodFont as ResourceId?;

        private var textPosY as Numeric? = null;
        private var textPosX as Numeric? = null;

        function initialize(params as TimeViewProps) {
            Box.initialize(params);

            var timeType = params.get(:type);
            self._timeType = timeType != null ? timeType : TimeViewType.HOURS;

            var textAlignment = params.get(:textAlignment);
            self._textAlignment = textAlignment != null ? textAlignment : Graphics.TEXT_JUSTIFY_LEFT;

            var aodFont = params.get(:aodFont);
            self._aodFont = aodFont != null ? aodFont : null;

            self.calcTextPosition();
        }

        protected function getTimeFont() as Resource or Number {
            if (self.isAod && self._aodFont != null) {
                return ResourcesCache.get(self._aodFont);
            }

            return self.getFont();
        }

        private function getHours() as Number {
            var hours = TimeStackModule.currentTime().hour;

            if (!GlobalKeys.IS_24_HOUR && hours > 12) {
                hours = hours - 12;
            }

            return hours;
        }

        private function getMinutes() as Number {
            return TimeStackModule.currentTime().min;
        }

        protected function getTime() as Number {
            switch (self._timeType) {
                case TimeViewType.HOURS:
                    return self.getHours();

                default:
                case TimeViewType.MINUTES:
                    return self.getMinutes();
            }
        }

        private function calcTextPosition() as Void {
            var posX = self.getPosX();
            var posY = self.getPosY();
            var width = self.getWidth();
            var height = self.getHeight();

            switch (self._textAlignment) {
                case Graphics.TEXT_JUSTIFY_RIGHT:
                    posX += width;
                    break;
                case Graphics.TEXT_JUSTIFY_CENTER:
                    posX += width * 0.5;
                    posY += height * 0.5;
                    break;
                case Graphics.TEXT_JUSTIFY_VCENTER:
                    posY += height * 0.5;
                    break;
            }

            self.textPosX = posX;
            self.textPosY = posY;
        }

        protected function renderTime(time as Number, drawContext as Dc) as Void {
            var color = self.isAod ? self.aodColor : self.foregroundColor;

            drawContext.setColor(color, Graphics.COLOR_TRANSPARENT);
            drawContext.drawText(
                self.textPosX,
                self.textPosY,
                self.getTimeFont(),
                time.format("%02d"),
                self._textAlignment
            );
        }

        protected function render(drawContext as Dc) as Void {
            self.renderTime(self.getTime(), drawContext);
        }
    }
}
