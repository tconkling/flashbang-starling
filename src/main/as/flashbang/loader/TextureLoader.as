//
// aciv

package flashbang.loader {

import flash.display.BitmapData;

import react.Future;

import starling.textures.Texture;

/** Loads a Starling Texture from a Bitmap */
public class TextureLoader extends BitmapLoader {
    public static function load (urlOrByteArray :*, scale :Number = 1, survivesLostContext :Boolean = true) :Future {
        return new TextureLoader(urlOrByteArray, scale, survivesLostContext).begin();
    }

    public function TextureLoader (urlOrByteArray :*, scale :Number = 1, survivesLostContext :Boolean = true) {
        super(urlOrByteArray);
        _scale = scale;
        _survivesLostContext = survivesLostContext;
    }

    override protected function onBitmapLoaded (bmd :BitmapData) :void {
        var tex :Texture = Texture.fromBitmapData(bmd, false, false, _scale);
        if (!_survivesLostContext) {
            bmd.dispose();
        }
        _result.succeed(tex);
    }

    protected var _scale :Number;
    protected var _survivesLostContext :Boolean;
}
}
