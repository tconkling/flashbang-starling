//
// flashbang

package flashbang.input {

public class Input
{
    public static function newPointerListener (touchId :int) :PointerListenerBuilder {
        return new PointerListenerBuilderImpl(touchId);
    }

    public static function newTouchListener (onTouchesUpdated :Function) :TouchListener {
        return new CallbackTouchListener(onTouchesUpdated);
    }

    public static function newKeyboardListener (onKeyboardEvent :Function) :KeyboardListener {
        return new CallbackKeyboardListener(onKeyboardEvent);
    }
}
}

import flashbang.input.KeyboardListener;
import flashbang.input.PointerAdapter;
import flashbang.input.PointerListener;
import flashbang.input.PointerListenerBuilder;
import flashbang.input.TouchListener;

import starling.events.KeyboardEvent;
import starling.events.Touch;

class PointerListenerBuilderImpl
    implements PointerListenerBuilder
{
    public function PointerListenerBuilderImpl (touchId :int) { _touchId = touchId; }
    public function onPointerStart (f :Function) :PointerListenerBuilder { _onPointerStart = f; return this; }
    public function onPointerMove (f :Function) :PointerListenerBuilder { _onPointerMove = f; return this; }
    public function onPointerEnd (f :Function) :PointerListenerBuilder { _onPointerEnd = f; return this; }
    public function onPointerHover (f :Function) :PointerListenerBuilder { _onPointerHover = f; return this; }
    public function build () :PointerListener {
        return new CallbackPointerListener(_touchId, _onPointerStart, _onPointerMove, _onPointerEnd,
            _onPointerHover, _consumeAllTouches);
    }

    protected var _touchId :int;
    protected var _onPointerStart :Function;
    protected var _onPointerMove :Function;
    protected var _onPointerEnd :Function;
    protected var _onPointerHover :Function;
    protected var _consumeAllTouches :Boolean = true;
}

class CallbackPointerListener extends PointerAdapter
{
    public function CallbackPointerListener (touchId :int, onPointerStart :Function,
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

class CallbackTouchListener
    implements TouchListener
{
    public function CallbackTouchListener (f :Function) {
        _f = f;
    }

    public function onTouchesUpdated (touches :Vector.<Touch>) :Boolean {
        var result :* = _f(touches);
        return (result === undefined ? true : result as Boolean);
    }

    protected var _f :Function;
}

class CallbackKeyboardListener
    implements KeyboardListener
{
    public function CallbackKeyboardListener (f :Function) {
        _f = f;
    }

    public function onKeyboardEvent (k :KeyboardEvent) :Boolean {
        var result :* = _f(k);
        return (result === undefined ? true : result as Boolean);
    }

    protected var _f :Function;
}
