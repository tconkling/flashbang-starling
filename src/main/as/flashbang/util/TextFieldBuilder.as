//
// flashbang

package flashbang.util {

import starling.text.BitmapFont;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.utils.HAlign;
import starling.utils.VAlign;

public class TextFieldBuilder
{
    public function TextFieldBuilder (text :String = "") {
        this.text(text);
    }

    /** Creates the TextField */
    public function build () :TextField {
        var tf :TextField = new TextField(100, 100, "");
        for (var key :String in _props) {
            tf[key] = _props[key];
        }
        return tf;
    }

    /** The text to display. @default "" */
    public function text (val :String) :TextFieldBuilder {
        _props.text = val;
        return this;
    }

    /** The name of the font to use @default: "Verdana" */
    public function font (name :String) :TextFieldBuilder {
        _props.fontName = name;
        return this;
    }

    /**
     * The size of the font. For bitmap fonts, use <code>BitmapFont.NATIVE_SIZE</code> for
     * the original size.
     * @default 12
     */
    public function fontSize (val :Number) :TextFieldBuilder {
        _props.fontSize = val;
        return this;
    }

    /** Equivalent to <code>fontSize(BitmapFont.NATIVE_SIZE)</code> */
    public function bitmapFontNativeSize () :TextFieldBuilder {
        return fontSize(BitmapFont.NATIVE_SIZE);
    }

    /** The text color @default 0x0 (black) */
    public function color (val :uint) :TextFieldBuilder {
        _props.color = val;
        return this;
    }

    /**
     * The width of the TextField.
     * Ignored if TextFieldAutoSize is HORIZONTAL or BOTH_DIRECTIONS.
     * @default 100
     */
    public function width (val :Number) :TextFieldBuilder {
        _props.width = val;
        return this;
    }

    /**
     * The height of the TextField.
     * Ignored if TextFieldAutoSize is VERTICAL or BOTH_DIRECTIONS.
     * @default 100
     */
    public function height (val :Number) :TextFieldBuilder {
        _props.height = val;
        return this;
    }

    /**
     * Sets the TextField's autoSize param.
     * Called without a parameter is equivalent to TextFieldAutoSize.BOTH_DIRECTIONS.
     * @default "none"
     */
    public function autoSize (type :String = "bothDirections") :TextFieldBuilder {
        _props.autoSize = type;
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
        _props.autoScale = val;
        return this;
    }

    /** Specifies whether this object receives touch events. @default true */
    public function touchable (enabled :Boolean) :TextFieldBuilder {
        _props.touchable = enabled;
        return this;
    }

    /** Horizontal alignment. @default "center" */
    public function hAlign (type :String) :TextFieldBuilder {
        _props.hAlign = type;
        return this;
    }

    /** Vertical alignment. @default "center" */
    public function vAlign (type :String) :TextFieldBuilder {
        _props.vAlign = type;
        return this;
    }

    /** Equivalent to <code>hAlign(HAlign.LEFT)</code> */
    public function hAlignLeft () :TextFieldBuilder {
        return hAlign(HAlign.LEFT);
    }

    /** Equivalent to <code>hAlign(HAlign.CENTER)</code> */
    public function hAlignCenter () :TextFieldBuilder {
        return hAlign(HAlign.CENTER);
    }

    /** Equivalent to <code>hAlign(HAlign.RIGHT)</code> */
    public function hAlignRight () :TextFieldBuilder {
        return hAlign(HAlign.RIGHT);
    }

    /** Equivalent to <code>vAlign(VAlign.TOP)</code> */
    public function vAlignTop () :TextFieldBuilder {
        return vAlign(VAlign.TOP);
    }

    /** Equivalent to <code>vAlign(VAlign.CENTER)</code> */
    public function vAlignCenter () :TextFieldBuilder {
        return vAlign(VAlign.CENTER);
    }

    /** Equivalent to <code>vAlign(VAlign.BOTTOM)</code> */
    public function vAlignBottom () :TextFieldBuilder {
        return vAlign(VAlign.BOTTOM);
    }

    /** Specifies whether the text is boldface. @default false */
    public function bold (val :Boolean) :TextFieldBuilder {
        _props.bold = val;
        return this;
    }

    /** Specifies whether the text is italicized. @default false */
    public function italic (val :Boolean) :TextFieldBuilder {
        _props.italic = val;
        return this;
    }

    /** Specifies whether the text is underlined. @default false */
    public function underline (val :Boolean) :TextFieldBuilder {
        _props.underline = val;
        return this;
    }

    /** Specifies whether a border is shown around the TextField. @default false */
    public function border (val :Boolean) :TextFieldBuilder {
        _props.border = val;
        return this;
    }

    /** Specifies whether kerning is enabled. @default true */
    public function kerning (val :Boolean) :TextFieldBuilder {
        _props.kerning = val;
        return this;
    }

    protected var _props :Object = {};
}

}
