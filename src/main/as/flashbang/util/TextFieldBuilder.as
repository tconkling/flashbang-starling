//
// flashbang

package flashbang.util {

import starling.text.BitmapFont;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.text.TextFormat;
import starling.utils.Align;

public class TextFieldBuilder
{
    public function TextFieldBuilder (text :String = "") {
        this.text(text);
    }

    /** Creates the TextField */
    public function build () :TextField {
        var tf :TextField = new TextField(100, 100, _text, _format);
        tf.touchable = _touchable;
        tf.border = _border;
        tf.autoScale = _autoScale;
        tf.autoSize = _autoSize;

        if (!isNaN(_scale)) {
            tf.scale = _scale;
        }

        if (!isNaN(_width)) {
            tf.width = _width;
        }

        if (!isNaN(_height)) {
            tf.height = _height;
        }

        if (_autoSize != TextFieldAutoSize.NONE) {
            if (!isNaN(_maxWidth) && tf.width > _maxWidth) {
                tf.scale *= _maxWidth / tf.width
            }

            if (!isNaN(_maxHeight) && tf.height > _maxHeight) {
                tf.scale *= _maxHeight / tf.height;
            }
        }

        return tf;
    }

    /** The text to display. @default "" */
    public function text (val :String) :TextFieldBuilder {
        _text = val;
        return this;
    }

    /** The name of the font to use @default: "Verdana" */
    public function font (name :String) :TextFieldBuilder {
        this.format.font = name;
        return this;
    }

    /**
     * The size of the font. For bitmap fonts, use <code>BitmapFont.NATIVE_SIZE</code> for
     * the original size.
     * @default 12
     */
    public function fontSize (val :Number) :TextFieldBuilder {
        this.format.size = val;
        return this;
    }

    /** Equivalent to <code>fontSize(BitmapFont.NATIVE_SIZE)</code> */
    public function bitmapFontNativeSize () :TextFieldBuilder {
        return fontSize(BitmapFont.NATIVE_SIZE);
    }

    /** The text color @default 0x0 (black) */
    public function color (val :uint) :TextFieldBuilder {
        this.format.color = val;
        return this;
    }

    /**
     * The width of the TextField.
     * Ignored if TextFieldAutoSize is HORIZONTAL or BOTH_DIRECTIONS.
     * @default 100
     */
    public function width (val :Number) :TextFieldBuilder {
        _width = val;
        return this;
    }

    /**
     * The height of the TextField.
     * Ignored if TextFieldAutoSize is VERTICAL or BOTH_DIRECTIONS.
     * @default 100
     */
    public function height (val :Number) :TextFieldBuilder {
        _height = val;
        return this;
    }

    /**
     * Sets the TextField's autoSize param.
     * Called without a parameter is equivalent to TextFieldAutoSize.BOTH_DIRECTIONS.
     *
     * @default "none"
     */
    public function autoSize (type :String = "bothDirections") :TextFieldBuilder {
        _autoSize = type;
        return this;
    }

    /**
     * If set, the TextField will be scaled down, if necessary, so that its width == maxWidth.
     * Ignored if TextFieldAutoSize is NONE.
     */
    public function maxWidth (val :Number) :TextFieldBuilder {
        _maxWidth = val;
        return this;
    }

    /**
     * If set, the TextField will be scaled down, if necessary, so that its height == maxHeight.
     * Ignored if TextFieldAutoSize is NONE.
     */
    public function maxHeight (val :Number) :TextFieldBuilder {
        _maxHeight = val;
        return this;
    }

    /** Equivalent to <code>autoSize(TextFieldAutoSize.NONE)</code> */
    public function autoSizeNone () :TextFieldBuilder {
        return autoSize(TextFieldAutoSize.NONE);
    }

    /** Equivalent to <code>autoSize(TextFieldAutoSize.HORIZONTAL)</code> */
    public function autoSizeHorizontal () :TextFieldBuilder {
        return autoSize(TextFieldAutoSize.HORIZONTAL);
    }

    /** Equivalent to <code>autoSize(TextFieldAutoSize.VERTICAL)</code> */
    public function autoSizeVertical () :TextFieldBuilder {
        return autoSize(TextFieldAutoSize.VERTICAL);
    }

    /**
     * If true, the TextField will scale its font size down so that the complete
     * text fits into the TextField's bounds. Incompatible with autoSizing.
     * @default false
     */
    public function autoScale (val :Boolean) :TextFieldBuilder {
        _autoScale = val;
        return this;
    }

    /** Specifies whether this object receives touch events. @default true */
    public function touchable (enabled :Boolean) :TextFieldBuilder {
        _touchable = enabled;
        return this;
    }

    /** Horizontal alignment. @default "center" */
    public function hAlign (type :String) :TextFieldBuilder {
        this.format.horizontalAlign = type;
        return this;
    }

    /** Vertical alignment. @default "center" */
    public function vAlign (type :String) :TextFieldBuilder {
        this.format.verticalAlign = type;
        return this;
    }

    /** Equivalent to <code>hAlign(Align.LEFT)</code> */
    public function hAlignLeft () :TextFieldBuilder {
        return hAlign(Align.LEFT);
    }

    /** Equivalent to <code>hAlign(Align.CENTER)</code> */
    public function hAlignCenter () :TextFieldBuilder {
        return hAlign(Align.CENTER);
    }

    /** Equivalent to <code>hAlign(Align.RIGHT)</code> */
    public function hAlignRight () :TextFieldBuilder {
        return hAlign(Align.RIGHT);
    }

    /** Equivalent to <code>vAlign(Align.TOP)</code> */
    public function vAlignTop () :TextFieldBuilder {
        return vAlign(Align.TOP);
    }

    /** Equivalent to <code>vAlign(Align.CENTER)</code> */
    public function vAlignCenter () :TextFieldBuilder {
        return vAlign(Align.CENTER);
    }

    /** Equivalent to <code>vAlign(Align.BOTTOM)</code> */
    public function vAlignBottom () :TextFieldBuilder {
        return vAlign(Align.BOTTOM);
    }

    /** Specifies whether the text is boldface. @default false */
    public function bold (val :Boolean) :TextFieldBuilder {
        this.format.bold = val;
        return this;
    }

    /** Specifies whether the text is italicized. @default false */
    public function italic (val :Boolean) :TextFieldBuilder {
        this.format.italic = val;
        return this;
    }

    /** Specifies whether the text is underlined. @default false */
    public function underline (val :Boolean) :TextFieldBuilder {
        this.format.underline = val;
        return this;
    }

    /** Specifies whether a border is shown around the TextField. @default false */
    public function border (val :Boolean) :TextFieldBuilder {
        _border = val;
        return this;
    }

    /** Specifies whether kerning is enabled. @default true */
    public function kerning (val :Boolean) :TextFieldBuilder {
        this.format.kerning = val;
        return this;
    }

    /** Specifies the scale of the TextField. @default 1.0.
     *
     * Calling this multiple times will multiply the previously-set scale value.
     * (Use `resetScale` to set override any previous scale changes.) */
    public function scale (val :Number) :TextFieldBuilder {
        _scale *= val;
        return this;
    }

    public function resetScale (val :Number) :TextFieldBuilder {
        _scale = val;
        return this;
    }

    private function get format () :TextFormat {
        if (_format == null) {
            _format = new TextFormat();
        }
        return _format;
    }

    private var _format :TextFormat;
    private var _text :String;
    private var _touchable :Boolean = true;
    private var _border :Boolean;
    private var _autoScale :Boolean;
    private var _autoSize :String = TextFieldAutoSize.NONE;
    private var _maxWidth :Number = NaN;
    private var _maxHeight :Number = NaN;
    private var _width :Number = NaN;
    private var _height :Number = NaN;
    private var _scale :Number = 1;
}

}
