//
// flashbang

package flashbang.input {

public class PointerListenerBuilder
{
    public function PointerListenerBuilder (touchId :int) { _touchId = touchId; }
    public function onPointerStart (f :Function) :PointerListenerBuilder { _onPointerStart = f; return this; }
    public function onPointerMove (f :Function) :PointerListenerBuilder { _onPointerMove = f; return this; }
    public function onPointerEnd (f :Function) :PointerListenerBuilder { _onPointerEnd = f; return this; }
    public function onPointerHover (f :Function) :PointerListenerBuilder { _onPointerHover = f; return this; }
    public function create () :PointerAdapter {
        return new CallbackPointerAdapter(_touchId, _onPointerStart, _onPointerMove, _onPointerEnd,
            _onPointerHover, _consumeAllTouches);
    }

    protected var _touchId :int;
    protected var _onPointerStart :Function;
    protected var _onPointerMove :Function;
    protected var _onPointerEnd :Function;
    protected var _onPointerHover :Function;
    protected var _consumeAllTouches :Boolean = true;
}

}

import starling.events.Touch;

import flashbang.input.PointerAdapter;

class CallbackPointerAdapter extends PointerAdapter
{
    public function CallbackPointerAdapter (touchId :int, onPointerStart :Function,
        onPointerMove :Function, onPointerEnd :Function, onPointerHover :Function,
        consumeAllTouches :Boolean)
    {
        super(touchId, consumeAllTouches);
        _onPointerStart = onPointerStart;
        _onPointerMove = onPointerMove;
        _onPointerEnd = onPointerEnd;
        _onPointerHover = onPointerHover;
    }

    override public function onPointerStart (touch :Touch) :Boolean {
        if (_onPointerStart != null) {
            _onPointerStart(touch);
        }
        return true;
    }

    override public function onPointerMove (touch :Touch) :Boolean {
        if (_onPointerMove != null) {
            _onPointerMove(touch);
        }
        return true;
    }

    override public function onPointerEnd (touch :Touch) :Boolean {
        if (_onPointerEnd != null) {
            _onPointerEnd(touch);
        }
        return true;
    }

    override public function onPointerHover (touch :Touch) :Boolean {
        if (_onPointerHover != null) {
            _onPointerHover(touch);
        }
        return true;
    }

    protected var _onPointerStart :Function;
    protected var _onPointerMove :Function;
    protected var _onPointerEnd :Function;
    protected var _onPointerHover :Function;
}
