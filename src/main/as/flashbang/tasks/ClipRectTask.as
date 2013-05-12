//
// flashbang

package flashbang.tasks {

import flash.geom.Rectangle;

import starling.display.Sprite;

public class ClipRectTask extends SpriteTask
{
    public function ClipRectTask (rect :Rectangle, time :Number = 0, easing :Function = null, sprite :Sprite = null) {
        super(time, easing, sprite);
        _endClip = rect.clone();
    }

    override protected function updateValues () :void {
        if (_startClip == null) {
            const clip :Rectangle = _target.clipRect;
            _startClip = (clip != null ? clip.clone() : _target.bounds);
            _curClip = new Rectangle();
        }

        _curClip.x = interpolate(_startClip.x, _endClip.x);
        _curClip.y = interpolate(_startClip.y, _endClip.y);
        _curClip.width = interpolate(_startClip.width, _endClip.width);
        _curClip.height = interpolate(_startClip.height, _endClip.height);
        _target.clipRect = _curClip;
    }

    protected var _endClip :Rectangle;
    protected var _startClip :Rectangle;
    protected var _curClip :Rectangle;
}
}
