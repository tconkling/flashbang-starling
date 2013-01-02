//
// demo

package demo {

import starling.display.Quad;

import flashbang.AppMode;
import flashbang.objects.Button;
import flashbang.objects.SimpleTextButton;

public class PauseMode extends AppMode
{
    override protected function setup () :void
    {
        super.setup();

        var quad :Quad = new Quad(Demo.WIDTH, Demo.HEIGHT, 0);
        quad.alpha = 0.5;
        this.modeSprite.addChild(quad);

        var resume :Button = new SimpleTextButton("Resume", 18);
        resume.display.x = (Demo.WIDTH - resume.display.width) * 0.5;
        resume.display.y = Demo.HEIGHT - resume.display.height - 20;
        addObject(resume, this.modeSprite);
        _regs.addSignalListener(resume.clicked, function () :void {
            viewport.popMode();
        });
    }
}
}
