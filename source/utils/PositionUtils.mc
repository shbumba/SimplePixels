import Toybox.Lang;

module PositionUtils {
    enum AlignmentEnum {
        ALIGN_START = 1,
        ALIGN_CENTER,
        ALIGN_END
    }

    function parsePosition(position as String, size as Number) as Numeric {
        var mode = position.find("%") ? "percent" : "regular";
        var originalPosition = position.toFloat();

        var result = 0;

        switch (mode) {
            case "percent":
                result = originalPosition.toFloat() / 100;
                result = size.toFloat() * result;
                break;
            case "regular":
                result = originalPosition;
                break;
        }

        return result;
    }

    function calcAlignmentShift(alignment as AlignmentEnum, pointSize as Number) as Numeric {
        var result = 0;

        switch (alignment) {
            case ALIGN_START:
                result = 0;
                break;
            case ALIGN_END:
                result = pointSize;
                break;
            case ALIGN_CENTER:
                result = pointSize.toFloat() / 2;
                break;
        }

        return result;
    }
}
