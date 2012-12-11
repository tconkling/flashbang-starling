//
// demo

package demo {

import starling.events.TouchEvent;
import starling.events.TouchPhase;

import flashbang.AppMode;
import flashbang.resource.MovieResource;

import flump.display.Movie;

public class GameMode extends AppMode
{
    override protected function setup () :void
    {
        super.setup();

        var movie :Movie = MovieResource.create("flump/walk");
        movie.x = Demo.WIDTH / 2;
        movie.y = Demo.HEIGHT - 100;
        this.modeSprite.addChild(movie);

        _regs.addEventListener(this.modeSprite, TouchEvent.TOUCH, function (e :TouchEvent) :void {
            if (e.getTouch(modeSprite, TouchPhase.ENDED)) {
                viewport.pushMode(new PauseMode());
            }
        });
    }
}
}
