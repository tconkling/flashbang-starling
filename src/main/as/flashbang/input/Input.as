//
// flashbang

package flashbang.input {

import starling.display.DisplayObject;
import starling.events.Touch;

public class Input
{
    /** Returns a Touchable object for the given DisplayObject */
    public static function newTouchable (disp :DisplayObject) :Touchable {
        return new TouchableDisplayObject(disp);
    }

    /** Constructs a new DragHandler */
    public static function newDragHandler (touch :Touch) :DragHandlerBuilder {
        return new DragHandlerBuilderImpl(touch);
    }

    /**
     * Constructs a new PointerListener.
     * @property defaultHandledValue the default value to return when a function is not specified
     * for a given touch phase.
     */
    public static function newPointerListener (touchId :int, defaultHandledValue :Boolean = true) :PointerListenerBuilder {
        return new PointerListenerBuilderImpl(touchId, defaultHandledValue);
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

import flash.geom.Point;

import flashbang.input.DragHandler;
import flashbang.input.DragHandlerBuilder;
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
    public function PointerListenerBuilderImpl (touchId :int, defaultHandledValue :Boolean) { _touchId = touchId; _defaultHandledValue = defaultHandledValue; }
    public function onPointerStart (f :Function) :PointerListenerBuilder { _onPointerStart = f; return this; }
    public function onPointerMove (f :Function) :PointerListenerBuilder { _onPointerMove = f; return this; }
    public function onPointerEnd (f :Function) :PointerListenerBuilder { _onPointerEnd = f; return this; }
    public function onPointerHover (f :Function) :PointerListenerBuilder { _onPointerHover = f; return this; }
    public function consumeOtherTouches (val :Boolean) :PointerListenerBuilder { _consumeOtherTouches = val; return this; }
    public function build () :PointerListener {
        return new CallbackPointerListener(_touchId, _onPointerStart, _onPointerMove, _onPointerEnd,
            _onPointerHover, _consumeOtherTouches, _defaultHandledValue);
    }

    protected var _touchId :int;
    protected var _onPointerStart :Function;
    protected var _onPointerMove :Function;
    protected var _onPointerEnd :Function;
    protected var _onPointerHover :Function;
    protected var _consumeOtherTouches :Boolean = true;
    protected var _defaultHandledValue :Boolean;
}

class CallbackPointerListener extends PointerAdapter
{
    public function CallbackPointerListener (touchId :int, onPointerStart :Function,
        onPointerMove :Function, onPointerEnd :Function, onPointerHover :Function,
        consumeAllTouches :Boolean, defaultHandledValue :Boolean)
    {
        super(touchId, consumeAllTouches);
        _onPointerStart = onPointerStart;
        _onPointerMove = onPointerMove;
        _onPointerEnd = onPointerEnd;
        _onPointerHover = onPointerHover;
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

    protected var _onPointerStart :Function;
    protected var _onPointerMove :Function;
    protected var _onPointerEnd :Function;
    protected var _onPointerHover :Function;
    protected var _defaultHandledValue :Boolean;
}

class DragHandlerBuilderImpl
    implements DragHandlerBuilder {

    public function DragHandlerBuilderImpl (touch :Touch) {
        _touch = touch;
    }

    public function onDragged (f :Function) :DragHandlerBuilder {
        _onDragged = f;
        return this;
    }

    public function onDragEnd (f :Function) :DragHandlerBuilder {
        _onDragEnd = f;
        return this;
    }

    public function build () :DragHandler {
        return new CallbackDragHandler(_touch, _onDragged, _onDragEnd);
    }

    protected var _touch :Touch;
    protected var _onDragged :Function;
    protected var _onDragEnd :Function;
}

class CallbackDragHandler extends PointerAdapter
    implements DragHandler
{
    public function CallbackDragHandler (touch :Touch, onDragged :Function, onDragEnd :Function) {
        super(touch.id, true);
        _start = new Point(touch.globalX, touch.globalY);
        _current = new Point(touch.globalX, touch.globalY);
        _onDragged = onDragged;
        _onDragEnd = onDragEnd;
    }

    public function get startLoc () :Point {
        return _start;
    }

    public function get currentLoc () :Point {
        return _current;
    }

    override public function onPointerMove (touch :Touch) :Boolean {
        if (_onDragged != null) {
            _current.setTo(touch.globalX, touch.globalY);
            _onDragged(_current, _start);
        }
        return true;
    }

    override public function onPointerEnd (touch :Touch) :Boolean {
        if (_onDragEnd != null) {
            _current.setTo(touch.globalX, touch.globalY);
            _onDragEnd(_current, _start);
        }
        return true;
    }

    protected var _start :Point;
    protected var _current :Point;

    protected var _onDragged :Function;
    protected var _onDragEnd :Function;
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
