//
// flashbang

package flashbang.tasks {

import aspire.util.Preconditions;

import flashbang.components.DisplayComponent;
import flashbang.core.GameObject;
import flashbang.core.ObjectTask;

import flump.display.Movie;

/** Plays a Flump movie once. Completes when the movie has ended. */
public class PlayMovieTask
    implements ObjectTask
{
    /**
     * Creates a PlayMovieTask
     *
     * @param movie The movie to play (or null if this is a SceneObject that contains a movie)
     * @param from The frame label or index to start playing from (or null to start on frame 0)
     * @param to The frame label or indext to play to (or null to end on the last frame)
     */
    public function PlayMovieTask (movie :Movie = null, from :Object = null, to :Object = null)
    {
        _movie = movie;
        _from = (from || Movie.FIRST_FRAME);
        _to = (to || Movie.LAST_FRAME);
    }
    
    public function update (dt :Number, obj :GameObject) :Boolean
    {
        if (!_started) {
            _target = _movie;
            if (_target == null) {
                var disp :DisplayComponent = obj as DisplayComponent;
                Preconditions.checkState(disp != null,
                    "PlayMovieTask: object doesn't implement DisplayComponent");
                _target = disp.display as Movie;
                Preconditions.checkState(_target != null,
                    "PlayMoveiTask: object does not contain a Movie displayObject");
            }
            
            _started = true;
            _target.goTo(_from);
            _target.playTo(_to);
        }
        
        return !(_target.isPlaying);
    }
    
    public function clone () :ObjectTask
    {
        return new PlayMovieTask(_movie, _from, _to);
    }
    
    protected var _movie :Movie;
    protected var _from :Object;
    protected var _to :Object;
    
    protected var _target :Movie;
    protected var _started :Boolean;
}
}
