//
// flashbang

package flashbang.resource {

import flashbang.core.Flashbang;

import flump.display.Library;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.textures.Texture;

public class ImageResource extends FlumpResource
{
    /**
     * Creates an Image from the ImageResource with the given name.
     * Throws an error if the resource doesn't exist.
     */
    public static function createImage (name :String, pixelSnapping :Boolean = false) :Image {
        var rsrc :ImageResource = Flashbang.rsrcs.requireResource(name);
        return rsrc.create(pixelSnapping);
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
        super(library, libraryName, imageName);
    }

    public function create (pixelSnapping :Boolean = false) :Image {
        var img :Image = _library.createImage(_symbolName);
        img.pixelSnapping = pixelSnapping;
        return img;
    }

    /** from FlumpResource */
    override public function createDisplayObject () :DisplayObject {
        return create();
    }

    /** @return the Texture associated with this ImageResource */
    public function get texture () :Texture {
        if (_texture == null) {
            _texture = _library.getImageTexture(_symbolName);
        }
        return _texture;
    }

    override protected function dispose () :void {
        super.dispose();
        _texture = null;
        // the Texture will be disposed by its Library
    }

    protected var _texture :Texture;
}
}

