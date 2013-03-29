//
// flashbang

package flashbang.tasks {

import flash.geom.Rectangle;

import flashbang.core.GameObject;

import starling.display.Sprite;

public class ClipRectTask extends SpriteTask
{
    public function ClipRectTask (rect :Rectangle, time :Number = 0, easing :Function = null, sprite :Sprite = null) {
        super(time, easing, sprite);
        _endClip = rect.clone();
    }

    override public function update (dt :Number, obj :GameObject) :Boolean {
        if (0 == _elapsedTime) {
            _target = getTarget(obj);
            const clip :Rectangle = _target.clipRect;
            _startClip = (clip != null ? clip.clone() : _target.bounds);
            _curClip = new Rectangle();
        }

        _elapsedTime += dt;
        _curClip.x = interpolate(_startClip.x, _endClip.x);
        _curClip.y = interpolate(_startClip.y, _endClip.y);
        _curClip.width = interpolate(_startClip.width, _endClip.width);
        _curClip.height = interpolate(_startClip.height, _endClip.height);

        _target.clipRect = _curClip;
        return (_elapsedTime >= _totalTime);
    }


    protected var _endClip :Rectangle;
    protected var _startClip :Rectangle;
    protected var _curClip :Rectangle;
}
}
