//
// flashbang

package flashbang.resource {

import starling.display.Image;

import flump.display.Library;

import flashbang.core.Flashbang;

public class ImageResource extends Resource
{
    /**
     * Creates an Image from the ImageResource with the given name.
     * Throws an error if the resource doesn't exist.
     */
    public static function createImage (name :String) :Image
    {
        var rsrc :ImageResource = Flashbang.rsrcs.requireResource(name);
        return rsrc.create();
    }

    /** Returns the ImageResource with the given name, or null if it doesn't exist */
    public static function get (name :String) :ImageResource
    {
        return Flashbang.rsrcs.getResource(name);
    }

    public function ImageResource (library :Library, libraryName :String, imageName :String)
    {
        super(libraryName + "/" + imageName);
        _library = library;
        _imageName = imageName;
    }

    public function create () :Image
    {
        return _library.createImage(_imageName);
    }
    
    override protected function unload () :void
    {
        _library = null;
    }

    protected var _library :Library;
    protected var _imageName :String;
}
}

