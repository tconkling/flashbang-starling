//
// Flashbang

package flashbang.tasks {

import flash.display.MovieClip;

import aspire.util.Preconditions;

import flashbang.GameObject;
import flashbang.components.DisplayComponent;

public class MovieTask extends InterpolatingTask
{
    public function MovieTask (time :Number, easing :Function, movie :MovieClip)
    {
        super(time, easing);
        _movie = movie;
    }

    protected function getTarget (obj :GameObject) :MovieClip
    {
        var movie :MovieClip = _movie;
        if (movie == null) {
            var dc :DisplayComponent = obj as DisplayComponent;
            Preconditions.checkState(dc != null, "obj does not implement DisplayComponent");
            movie = (dc.display as MovieClip);
            Preconditions.checkState(movie != null, "obj does not contain a MovieClip");
        }
        return movie;
    }

    protected var _movie :MovieClip;

    protected var _target :MovieClip;
}
}
