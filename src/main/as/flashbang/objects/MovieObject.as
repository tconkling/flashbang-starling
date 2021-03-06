//
// flashbang

package flashbang.objects {

import flashbang.resource.MovieResource;

import flump.display.Movie;

public class MovieObject extends SpriteObject
{
    public static function create (movieName :String) :MovieObject {
        return new MovieObject(MovieResource.createMovie(movieName));
    }

    public function MovieObject (movie :Movie) {
        super(movie);
        _movie = movie;
    }

    public function get movie () :Movie {
        return _movie;
    }

    protected var _movie :Movie;
}
}
