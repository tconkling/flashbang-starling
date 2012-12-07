//
// flashbang

package flashbang.resource {

import flashbang.Flashbang;

import flump.display.Library;
import flump.display.Movie;

public class MovieResource extends Resource
{
    public static function create (name :String) :Movie
    {
        var rsrc :MovieResource = Flashbang.rsrcs.requireResource(name);
        return rsrc.create();
    }

    public function MovieResource (library :Library, libraryName :String, movieName :String)
    {
        super(libraryName + "/" + movieName);
    }

    public function create () :Movie
    {
        return _library.createMovie(_movieName);
    }

    protected var _library :Library;
    protected var _movieName :String;
}
}
