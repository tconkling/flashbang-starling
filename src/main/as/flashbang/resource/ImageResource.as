//
// flashbang

package flashbang.resource {

import starling.display.DisplayObject;

import flashbang.Flashbang;

import flump.display.Library;

public class ImageResource extends Resource
{
    public static function create (name :String) :DisplayObject
    {
        var rsrc :ImageResource = Flashbang.rsrcs.requireResource(name);
        return rsrc.create();
    }

    public function ImageResource (library :Library, libraryName :String, imageName :String)
    {
        super(libraryName + "/" + imageName);
    }

    public function create () :DisplayObject
    {
        return _library.createImage(_imageName);
    }

    protected var _library :Library;
    protected var _imageName :String;
}
}

