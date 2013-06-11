//
// demo

package demo {

import flashbang.core.AppMode;
import flashbang.objects.Button;
import flashbang.objects.SimpleTextButton;

import starling.display.Quad;

public class PauseMode extends flashbang.core.AppMode
{
    override protected function setup () :void {
        super.setup();

        var quad :Quad = new Quad(Demo.WIDTH, Demo.HEIGHT, 0);
        quad.alpha = 0.5;
        this.modeSprite.addChild(quad);

        var resume :Button = new SimpleTextButton("Resume", 18);
        resume.display.x = (Demo.WIDTH - resume.display.width) * 0.5;
        resume.display.y = Demo.HEIGHT - resume.display.height - 20;
        addObject(resume, this.modeSprite);
        _regs.add(resume.clicked.connect(viewport.popMode));
    }
}
}
