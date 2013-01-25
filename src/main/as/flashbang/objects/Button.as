//
// flashbang

package flashbang.objects {

import flash.geom.Point;

import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import aspire.util.Registration;

import flashbang.input.PointerAdapter;
import flashbang.input.PointerListener;

import org.osflash.signals.Signal;

/**
 * A button base class. Abstract.
 */
public class Button extends SpriteObject
{
    /** Fired when the button is clicked */
    public const clicked :Signal = new Signal();

    public function get enabled () :Boolean
    {
        return (_state != DISABLED);
    }

    public function set enabled (val :Boolean) :void
    {
        if (val != this.enabled) {
            setState(val ? UP : DISABLED);
        }
    }

    /** Subclasses must override this to display the appropriate state */
    protected function showState (state :int) :void
    {
        throw new Error("abstract");
    }

    override protected function addedToMode () :void
    {
        showState(_state);

        var self :Button = this;
        _regs.addSignalListener(this.touchSignals.touchBegan, function (touch :Touch) :void {
            if (self.enabled && _captureReg == null) {
                var l :PointerListener = PointerAdapter.withTouchId(touch.id)
                    .onPointerMove(self.onPointerMove)
                    .onPointerEnd(self.onPointerEnd)
                    .create();
                _captureReg = _regs.add(self.mode.touchInput.registerListener(l));
                setState(DOWN);
            }
        });
    }

    protected function setState (val :int) :void
    {
        if (_state != val) {
            _state = val;
            if (_state == DISABLED) {
                cancelCapture();
            }
            showState(_state);
        }
    }

    protected function cancelCapture () :void
    {
        if (_captureReg != null) {
            _captureReg.cancel();
            _captureReg = null;
        }
    }

    protected function onPointerMove (touch :Touch) :void
    {
        _pointerOver = hitTest(touch);
        setState(_pointerOver ? DOWN : UP);
    }

    protected function onPointerEnd (touch :Touch) :void
    {
        setState(UP);
        cancelCapture();
        // emit the signal after doing everything else, because a signal handler could change
        // our state
        if (hitTest(touch)) {
            this.clicked.dispatch();
        }
    }

    protected function hitTest (touch :Touch) :Boolean
    {
        var p :Point = _sprite.globalToLocal(new Point(touch.globalX, touch.globalY));
        return (_sprite.hitTest(p, true) != null);
    }

    protected var _state :int = 0;
    protected var _pointerOver :Boolean;
    protected var _captureReg :Registration;

    protected static const UP :int = 0;
    protected static const DOWN :int = 1;
    protected static const OVER :int = 2;
    protected static const DISABLED :int = 3;
}
}
