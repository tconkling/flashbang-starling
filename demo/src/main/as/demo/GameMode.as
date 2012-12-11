//
// demo

package demo {

import flashbang.AppMode;
import flashbang.resource.MovieResource;

import flump.display.Movie;

public class GameMode extends AppMode
{
    override protected function setup () :void
    {
        super.setup();

        var movie :Movie = MovieResource.create("flump/walk");
        movie.x = 160;
        movie.y = 380;
        this.modeSprite.addChild(movie);
    }
}
}
