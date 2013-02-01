//
// demo

package demo {

import flashbang.core.AppMode;
import flashbang.core.ObjectTask;
import flashbang.objects.Button;
import flashbang.objects.MovieObject;
import flashbang.objects.SimpleTextButton;
import flashbang.tasks.LocationTask;
import flashbang.tasks.RepeatingTask;
import flashbang.tasks.ScaleTask;
import flashbang.tasks.SerialTask;

public class GameMode extends AppMode
{
    override protected function setup () :void
    {
        super.setup();

        var obj :MovieObject = MovieObject.create("flump/walk");
        obj.display.x = Demo.WIDTH;
        obj.display.y = Demo.HEIGHT / 2;
        addObject(obj, this.modeSprite);

        obj.addTask(new RepeatingTask(function () :ObjectTask {
            return new SerialTask(
                new ScaleTask(1, 1),
                new LocationTask(0, obj.display.y, 5),
                new ScaleTask(-1, 1),
                new LocationTask(Demo.WIDTH, obj.display.y, 5));
        }));

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
