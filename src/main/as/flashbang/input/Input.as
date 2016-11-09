//
// flashbang

package flashbang.input {

import starling.display.DisplayObject;

public class Input
{
    /** Returns a Touchable object for the given DisplayObject */
    public static function newTouchable (disp :DisplayObject) :Touchable {
        return new TouchableDisplayObject(disp);
    }

    /**
     * Constructs a new PointerListener.
     * @property defaultHandledValue the default value to return when a function is not specified
     * for a given touch phase.
     */
    public static function newPointerListener (defaultHandledValue :Boolean = true) :PointerListenerBuilder {
        return new PointerListenerBuilderImpl(defaultHandledValue);
    }

    /** Constructs a new TouchListener */
    public static function newTouchListener (onTouchesUpdated :Function) :TouchListener {
        return new CallbackTouchListener(onTouchesUpdated);
    }

    /** Constructs a new KeyboardListener */
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
    public function PointerListenerBuilderImpl (defaultHandledValue :Boolean) { _defaultHandledValue = defaultHandledValue; }
    public function onPointerStart (f :Function) :PointerListenerBuilder { _onPointerStart = f; return this; }
    public function onPointerMove (f :Function) :PointerListenerBuilder { _onPointerMove = f; return this; }
    public function onPointerEnd (f :Function) :PointerListenerBuilder { _onPointerEnd = f; return this; }
    public function onPointerHover (f :Function) :PointerListenerBuilder { _onPointerHover = f; return this; }
    public function onPointerPreempted (f :Function) :PointerListenerBuilder { _onPointerPreempted = f; return this; }
    public function consumeOtherTouches (val :Boolean) :PointerListenerBuilder { _consumeOtherTouches = val; return this; }
    public function build () :PointerListener {
        return new CallbackPointerListener(_onPointerStart, _onPointerMove, _onPointerEnd,
            _onPointerHover, _onPointerPreempted, _consumeOtherTouches, _defaultHandledValue);
    }

    protected var _onPointerStart :Function;
    protected var _onPointerMove :Function;
    protected var _onPointerEnd :Function;
    protected var _onPointerHover :Function;
    protected var _onPointerPreempted :Function;
    protected var _consumeOtherTouches :Boolean = true;
    protected var _defaultHandledValue :Boolean;
}

class CallbackPointerListener extends PointerAdapter
{
    public function CallbackPointerListener (onPointerStart :Function,
        onPointerMove :Function, onPointerEnd :Function, onPointerHover :Function,
        onPointerPreempted: Function, consumeOtherTouches :Boolean,
        defaultHandledValue :Boolean)
    {
        super(consumeOtherTouches);
        _onPointerStart = onPointerStart;
        _onPointerMove = onPointerMove;
        _onPointerEnd = onPointerEnd;
        _onPointerHover = onPointerHover;
        _onPointerPreempted = onPointerPreempted;
        _defaultHandledValue = defaultHandledValue;
    }

    override public function onPointerStart (touch :Touch) :Boolean {
        if (_onPointerStart != null) {
            var result :* = _onPointerStart(touch);
            return (result === undefined ? true : result as Boolean);
        }
        return _defaultHandledValue;
    }

    override public function onPointerMove (touch :Touch) :Boolean {
        if (_onPointerMove != null) {
            var result :* = _onPointerMove(touch);
            return (result === undefined ? true : result as Boolean);
        }
        return _defaultHandledValue;
    }

    override public function onPointerEnd (touch :Touch) :Boolean {
        if (_onPointerEnd != null) {
            var result :* = _onPointerEnd(touch);
            return (result === undefined ? true : result as Boolean);
        }
        return _defaultHandledValue;
    }

    override public function onPointerHover (touch :Touch) :Boolean {
        if (_onPointerHover != null) {
            var result :* = _onPointerHover(touch);
            return (result === undefined ? true : result as Boolean);
        }
        return _defaultHandledValue;
    }

    override public function onPointerPreempted (touch :Touch) :void {
        if (_onPointerPreempted != null) {
            _onPointerPreempted(touch);
        }
    }

    protected var _onPointerStart :Function;
    protected var _onPointerMove :Function;
    protected var _onPointerEnd :Function;
    protected var _onPointerHover :Function;
    protected var _onPointerPreempted :Function;
    protected var _defaultHandledValue :Boolean;
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

    public function onTouchesPreempted (touches :Vector.<Touch>) :void {
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
