//
// Flashbang

package flashbang.objects {

import flashbang.objects.MovieObject;
import flashbang.util.CachedMovie;
import flashbang.util.MovieCache;

/** MovieObject that releases its movie back to a cache, rather than destroying it */
public class CachedMovieObject extends MovieObject
{
    public static function create (cache :MovieCache, movieName :String) :CachedMovieObject {
        return new CachedMovieObject(cache.requireMovie(movieName));
    }

    public function CachedMovieObject (cachedMovie :CachedMovie) {
        super(cachedMovie.movie);
        _cached = cachedMovie;
    }

    override protected function dispose () :void {
        _cached.release();
        // null out displayObject so that it doesn't get disposed.
        _displayObject = null;
        super.dispose();
    }

    protected var _cached :CachedMovie;
}
}
