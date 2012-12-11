//
// demo

package demo {

import starling.display.Quad;

import flashbang.AppMode;

public class PauseMode extends AppMode
{
    override protected function setup () :void
    {
        super.setup();

        var quad :Quad = new Quad(Demo.WIDTH, Demo.HEIGHT, 0);
        quad.alpha = 0.5;
        this.modeSprite.addChild(quad);
    }
}
}
