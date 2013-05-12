//
// Flashbang

package flashbang.objects {

import flash.geom.Point;

import starling.events.Touch;

import aspire.util.Preconditions;
import aspire.util.Registration;

import flashbang.core.GameObject;

public class Dragger extends GameObject
{
    public function get dragging () :Boolean {
        return _dragReg != null;
    }

    public function startDrag (touch :Touch) :void {
        Preconditions.checkState(!this.dragging, "already dragging");
        _listener = new DragListener(touch, this.onDragged,
            function (current :Point, start :Point) :void {
                // stop the drag before calling onDragEnd, to allow safe destruction of the
                // dragger from within onDragEnd
                stopDrag(true);
                onDragEnd(current, start);
            });
        _dragReg = this.mode.touchInput.registerListener(_listener);

        onDragStart(_listener.start);
    }

    public function cancelDrag () :void {
        stopDrag(false);
    }

    override protected function removed () :void {
        cancelDrag();
        super.removed();
    }

    protected function stopDrag (dragCompleted :Boolean) :void {
        if (_dragReg != null) {
            _dragReg.cancel();
            _dragReg = null;
            if (!dragCompleted) {
                var start :Point = _listener.start;
                var current :Point = _listener.current;
                _listener = null;
                onDragCanceled(current != null ? current : start, start);
            }
        }
    }

    protected function onDragStart (start :Point) :void {}
    protected function onDragged (current :Point, start :Point) :void {}
    protected function onDragEnd (current :Point, start :Point) :void {}
    protected function onDragCanceled (last :Point, start :Point) :void {}

    protected var _listener :DragListener;
    protected var _dragReg :Registration;
}
}

import flash.geom.Point;

import starling.events.Touch;

import flashbang.input.PointerAdapter;

class DragListener extends PointerAdapter
{
    public function DragListener (touch :Touch, onTouchMove :Function, onTouchEnd :Function) {
        super(touch.id);
        _start = new Point(touch.globalX, touch.globalY);
        _onTouchMove = onTouchMove;
        _onTouchEnd = onTouchEnd;
    }

    public function get start () :Point {
        return _start;
    }

    public function get current () :Point {
        return _current;
    }

    override public function onPointerMove (touch :Touch) :Boolean {
        _current = new Point(touch.globalX, touch.globalY);
        _onTouchMove(_current, _start);
        return true;
    }

    override public function onPointerEnd (touch :Touch) :Boolean {
        _current = new Point(touch.globalX, touch.globalY);
        _onTouchEnd(_current, _start);
        return true;
    }

    protected var _start :Point;
    protected var _current :Point;

    protected var _onTouchMove :Function;
    protected var _onTouchEnd :Function;
}
