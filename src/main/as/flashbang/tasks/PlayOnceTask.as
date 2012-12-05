//
// Flashbang

package flashbang.tasks {

import flash.display.MovieClip;

/** Plays a movie clip from its first frame until its last and then stops it. */
public class PlayOnceTask extends GotoAndPlayUntilTask
{
    public function PlayOnceTask (movie :MovieClip = null)
    {
        super(null, null, movie);
    }
}
}
