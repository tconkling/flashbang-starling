//
// flashbang

package flashbang.resource {

import flashbang.core.Flashbang;

import flump.display.Library;

import starling.display.Image;
import starling.textures.Texture;

public class ImageResource extends Resource
{
    /**
     * Creates an Image from the ImageResource with the given name.
     * Throws an error if the resource doesn't exist.
     */
    public static function createImage (name :String) :Image {
        var rsrc :ImageResource = Flashbang.rsrcs.requireResource(name);
        return rsrc.create();
    }

    /** Returns the ImageResource with the given name, or null if it doesn't exist */
    public static function get (name :String) :ImageResource {
        return Flashbang.rsrcs.getResource(name);
    }

    /** Returns the ImageResource with the given name. Throws an Error if it doesn't exist. */
    public static function require (name :String) :ImageResource {
        return Flashbang.rsrcs.requireResource(name);
    }

    public function ImageResource (library :Library, libraryName :String, imageName :String) {
        super(libraryName + "/" + imageName);
        _library = library;
        _imageName = imageName;
    }

    public function create () :Image {
        return _library.createImage(_imageName);
    }

    /** @return the Texture associated with this ImageResource */
    public function get texture () :Texture {
        if (_texture == null) {
            _texture = _library.getImageTexture(_imageName);
        }
        return _texture;
    }

    override protected function dispose () :void {
        _library = null;
        _texture = null;
    }

    protected var _library :Library;
    protected var _imageName :String;
    protected var _texture :Texture;
}
}

