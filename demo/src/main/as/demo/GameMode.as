//
// demo

package demo {

import flashbang.AppMode;
import flashbang.objects.Button;
import flashbang.objects.MovieObject;
import flashbang.objects.SimpleTextButton;

public class GameMode extends AppMode
{
    override protected function setup () :void
    {
        super.setup();

        var obj :MovieObject = MovieObject.create("flump/walk");
        obj.display.x = Demo.WIDTH / 2;
        obj.display.y = Demo.HEIGHT / 2;
        addObject(obj, this.modeSprite);

        var pause :Button = new SimpleTextButton("Pause", 18);
        pause.display.x = (Demo.WIDTH - pause.display.width) * 0.5;
        pause.display.y = Demo.HEIGHT - pause.display.height - 20;
        addObject(pause, this.modeSprite);
        _regs.addSignalListener(pause.clicked, function () :void {
            viewport.pushMode(new PauseMode());
        });
    }
}
}
