//
// flashbang

package flashbang.objects {

import starling.display.DisplayObject;

import flashbang.core.GameObject;
import flashbang.components.DisplayComponent;
import flashbang.resource.MovieResource;

import flump.display.Movie;

public class MovieObject extends GameObject
    implements DisplayComponent
{
    public static function create (movieName :String) :MovieObject {
        return new MovieObject(MovieResource.createMovie(movieName));
    }

    public function MovieObject (movie :Movie) {
        _movie = movie;
    }

    public function get display () :DisplayObject {
        return _movie;
    }

    override protected function update (dt :Number) :void {
        _movie.advanceTime(dt);
    }

    protected var _movie :Movie;
}
}
