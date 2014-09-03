//
// flashbang

package flashbang.resource {

import flashbang.core.Flashbang;

import flump.display.Library;
import flump.display.Movie;

import starling.display.DisplayObject;

public class MovieResource extends FlumpResource
{
    /**
     * Creates a Movie from the MovieResource with the given name.
     * Throws an error if the resource doesn't exist.
     */
    public static function createMovie (name :String) :Movie {
        var rsrc :MovieResource = Flashbang.rsrcs.requireResource(name);
        return rsrc.create();
    }

    /** Returns the MovieResource with the given name, or null if it doesn't exist */
    public static function get (name :String) :MovieResource  {
        return Flashbang.rsrcs.getResource(name);
    }

    public function MovieResource (library :Library, libraryName :String, movieName :String) {
        super(library, libraryName, movieName);
    }

    public function create () :Movie {
        return _library.createMovie(_symbolName);
    }

    /** from FlumpResource */
    override public function createDisplayObject () :DisplayObject {
        return create();
    }
}
}
