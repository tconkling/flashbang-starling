//
// flashbang

package flashbang.objects {

import flump.display.Movie;

/** A button whose states are defined by frames in a movie */
public class MovieButton extends Button
{
    public function MovieButton (movie :Movie) {
        _movie = movie;
        _sprite.addChild(_movie);
        _movie.stop();
    }

    override protected function showState (state :int) :void {
        switch (state) {
        case UP: _movie.goTo("up"); break;
        case DOWN: _movie.goTo("down"); break;
        case OVER: _movie.goTo("over"); break;
        case DISABLED: _movie.goTo("disabled"); break;
        }
    }

    protected var _movie :Movie;
}
}
