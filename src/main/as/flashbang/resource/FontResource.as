//
// flashbang

package flashbang.resource {

import aspire.util.Preconditions;

import flashbang.core.Flashbang;

import starling.text.BitmapFont;
import starling.text.TextField;

public class FontResource extends Resource
{
    /** Returns the FontResource with the given name. Throws an error if it doesn't exist. */
    public static function require (name :String) :FontResource {
        return Flashbang.rsrcs.requireResource(name);
    }

    /** Returns the FontResource with the given name, or null if it doesn't exist */
    public static function get (name :String) :FontResource {
        return Flashbang.rsrcs.getResource(name);
    }

    public function FontResource (name :String, font :BitmapFont) {
        super(name);
        _font = font;
    }

    public function get font () :BitmapFont {
        return _font;
    }

    override protected function added () :void {
        // The ResourceManager should prevent this from ever happening
        Preconditions.checkState(TextField.getBitmapFont(name) == null,
            "A font with this name already exists", "name", name);

        TextField.registerCompositor(_font, name);
    }

    override protected function dispose () :void {
        TextField.unregisterCompositor(_name, /*dispose=*/true);
        _font = null;
    }

    protected var _font :BitmapFont;
}
}
