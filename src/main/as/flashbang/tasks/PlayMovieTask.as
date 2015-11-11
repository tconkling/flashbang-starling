//
// flashbang

package flashbang.tasks {

import aspire.util.Preconditions;

import flashbang.components.DisplayComponent;
import flashbang.core.ObjectTask;
import flashbang.core.Updatable;

import flump.display.Movie;

/** Plays a Flump movie once. Completes when the movie has ended. */
public class PlayMovieTask extends ObjectTask
    implements Updatable
{
    /**
     * Creates a PlayMovieTask
     *
     * @param from The frame label or index to start playing from (or null to start on frame 0)
     * @param to The frame label or indext to play to (or null to end on the last frame)
     * @param target The movie to play (or null if this is a SceneObject that contains a movie)
     */
    public function PlayMovieTask (from :Object = null, to :Object = null, target :Movie = null) {
        _movie = target;
        _from = (from || Movie.FIRST_FRAME);
        _to = (to || Movie.LAST_FRAME);
    }

    public function update (dt :Number) :void  {
        if (!_started) {
            if (_movie == null) {
                var disp :DisplayComponent = this.parent as DisplayComponent;
                Preconditions.checkState(disp != null,
                    "PlayMovieTask: object doesn't implement DisplayComponent");
                _movie = disp.display as Movie;
                Preconditions.checkState(_movie != null,
                    "PlayMovieTask: object does not contain a Movie displayObject");
            }

            _started = true;
            _movie.goTo(_from);
            _movie.playTo(_to);
        }

        if (!_movie.isPlaying) {
            destroySelf();
        }
    }

    protected var _movie :Movie;
    protected var _from :Object;
    protected var _to :Object;

    protected var _started :Boolean;
}
}
