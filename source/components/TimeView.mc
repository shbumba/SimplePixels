import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import TimeStackModule;
import GlobalKeys;

module Components {
    module TimeViewType {
        enum Enum {
            HOURS = 1,
            MINUTES = 2
        }
    }

    typedef TimeViewProps as BoxProps or
        {
        :type as TimeViewType.Enum?,
        :textAligment as Graphics.TextJustification?
    };

    class TimeView extends Box {
        protected var _timeType as TimeViewType.Enum;
        protected var _textAligment as Graphics.TextJustification;

        private var textPosY as Numeric? = null;
        private var textPosX as Numeric? = null;

        function initialize(params as TimeViewProps) {
            Box.initialize(params);

            var timeType = params.get(:type);
            self._timeType = timeType != null ? timeType : TimeViewType.HOURS;

            var textAligment = params.get(:textAligment);
            self._textAligment = textAligment != null ? textAligment : Graphics.TEXT_JUSTIFY_LEFT;

            self.calcTextPosition();
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

            switch (self._textAligment) {
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
            if (self.isAod && GlobalKeys.IS_AMOLED) {
                drawContext.setColor(self.aodColor, Graphics.COLOR_TRANSPARENT);
                if (self._timeType == TimeViewType.HOURS) {
                    drawContext.drawText(
                        self.textPosX,
                        self.textPosY,
                        GlobalKeys.IS_AMOLED ? ResourcesCache.get(Rez.Fonts.hours_aod) : self.getFont(),
                        time.format("%02d"),
                        self._textAligment
                    );
                } else {
                    drawContext.drawText(
                        self.textPosX,
                        self.textPosY,
                        GlobalKeys.IS_AMOLED ? ResourcesCache.get(Rez.Fonts.minutes_aod) : self.getFont(),
                        time.format("%02d"),
                        self._textAligment
                    );
                }
            } else {
                drawContext.setColor(self.foregroundColor, Graphics.COLOR_TRANSPARENT);
                drawContext.drawText(
                    self.textPosX,
                    self.textPosY,
                    self.getFont(),
                    time.format("%02d"),
                    self._textAligment
                );
            }
        }

        protected function render(drawContext as Dc) as Void {
            self.renderTime(self.getTime(), drawContext);
        }
    }
}
