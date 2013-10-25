//
// flashbang

package flashbang.objects {

import flashbang.resource.MovieResource;

import flump.display.Movie;

/** A button whose states are defined by frames in a movie */
public class MovieButton extends Button
{
    public static function create (movieName :String) :MovieButton {
        return new MovieButton(MovieResource.createMovie(movieName));
    }

    public function MovieButton (movie :Movie) {
        super(_movie = movie);
        _movie.playChildrenOnly();
    }

    override protected function showState (state :int) :void {
        // use UP as a fallback when we don't have a label for the given state
        if (state != UP && !_movie.hasLabel(STATE_LABELS[state])) {
            state = UP;
        }
        _movie.goTo(STATE_LABELS[state]);
    }

    protected var _movie :Movie;

    protected static const STATE_LABELS :Vector.<String> = new <String>[
        "up", "down", "over", "disabled"
    ];
}
}
