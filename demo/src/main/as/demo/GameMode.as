//
// demo

package demo {

import starling.events.TouchEvent;
import starling.events.TouchPhase;

import flashbang.AppMode;
import flashbang.objects.MovieObject;

public class GameMode extends AppMode
{
    override protected function setup () :void
    {
        super.setup();

        var obj :MovieObject = MovieObject.create("flump/walk");
        obj.display.x = Demo.WIDTH / 2;
        obj.display.y = Demo.HEIGHT - 100;
        addObject(obj, this.modeSprite);

        _regs.addEventListener(this.modeSprite, TouchEvent.TOUCH, function (e :TouchEvent) :void {
            if (e.getTouch(modeSprite, TouchPhase.ENDED)) {
                viewport.pushMode(new PauseMode());
            }
        });
    }
}
}
