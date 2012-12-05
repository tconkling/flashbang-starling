//
// Flashbang

package flashbang.objects {

import flash.geom.Point;

import starling.events.Touch;

import aspire.util.Preconditions;
import aspire.util.Registration;

import flashbang.GameObject;

public class Dragger extends GameObject
{
    public function get dragging () :Boolean
    {
        return _dragReg != null;
    }

    public function startDrag (e :Touch) :void
    {
        Preconditions.checkState(!this.dragging, "already dragging");
        _listener = new DragListener(new Point(e.globalX, e.globalY), this.onDragged,
            function (current :Point, start :Point) :void {
                // stop the drag before calling onDragEnd, to allow safe destruction of the
                // dragger from within onDragEnd
                stopDrag(true);
                onDragEnd(current, start);
            });
        _dragReg = this.mode.touchInput.registerListener(_listener);

        onDragStart(_listener.start);
    }

    public function cancelDrag () :void
    {
        stopDrag(false);
    }

    override protected function removedFromMode () :void
    {
        cancelDrag();
        super.removedFromMode();
    }

    protected function stopDrag (dragCompleted :Boolean) :void
    {
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

import flashbang.input.TouchReactor;

// TODO handle multitouch
class DragListener extends TouchReactor
{
    public function DragListener (start :Point, onTouchMove :Function, onTouchEnd :Function)
    {
        _start = start;
        _onTouchMove = onTouchMove;
        _onTouchEnd = onTouchEnd;
    }

    public function get start () :Point
    {
        return _start;
    }

    public function get current () :Point
    {
        return _current;
    }

    override public function onTouchMove (e :Touch) :Boolean
    {
        _current = new Point(e.globalX, e.globalY);
        _onTouchMove(_current, _start);
        return true;
    }

    override public function onTouchEnd (e :Touch) :Boolean
    {
        _current = new Point(e.globalX, e.globalY);
        _onTouchEnd(_current, _start);
        return true;
    }

    protected var _start :Point;
    protected var _current :Point;

    protected var _onTouchMove :Function;
    protected var _onTouchEnd :Function;
}
