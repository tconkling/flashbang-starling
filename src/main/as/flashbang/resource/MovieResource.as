//
// flashbang

package flashbang.resource {

import flump.display.Library;
import flump.display.Movie;

import flashbang.core.Flashbang;

public class MovieResource extends Resource
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
        super(libraryName + "/" + movieName);
        _library = library;
        _movieName = movieName;
    }

    public function create () :Movie {
        return _library.createMovie(_movieName);
    }

    override protected function unload () :void {
        _library = null;
    }

    protected var _library :Library;
    protected var _movieName :String;
}
}
