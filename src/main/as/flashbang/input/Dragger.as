//
// Flashbang

package flashbang.input {

import aspire.util.Preconditions;

import flash.geom.Point;

import flashbang.core.GameObject;

import react.Registration;

import starling.events.Touch;

public class Dragger extends GameObject
{
    public function get dragging () :Boolean {
        return _dragReg != null;
    }

    public function startDrag (touch :Touch) :void {
        Preconditions.checkState(!this.dragging, "already dragging");

        _handler = Input.newDragHandler(touch)
            .onDragged(this.onDragged)
            .onDragEnd(function (current :Point, start :Point) :void {
                // stop the drag before calling onDragEnd, to allow safe destruction of the
                // dragger from within onDragEnd
                stopDrag(true);
                onDragEnd(current, start);
            })
            .build();
        _dragReg = this.mode.touchInput.registerListener(_handler);

        onDragStart(_handler.startLoc);
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
            _dragReg.close();
            _dragReg = null;
            if (!dragCompleted) {
                var start :Point = _handler.startLoc;
                var current :Point = _handler.currentLoc;
                _handler = null;
                onDragCanceled(current, start);
            }
        }
    }

    protected function onDragStart (start :Point) :void {}
    protected function onDragged (current :Point, start :Point) :void {}
    protected function onDragEnd (current :Point, start :Point) :void {}
    protected function onDragCanceled (last :Point, start :Point) :void {}

    protected var _handler :DragHandler;
    protected var _dragReg :Registration;
}
}
