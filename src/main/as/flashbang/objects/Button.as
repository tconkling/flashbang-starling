//
// flashbang

package flashbang.objects {

import aspire.util.Registration;

import flash.geom.Point;

import flashbang.input.PointerAdapter;
import flashbang.input.PointerListener;
import flashbang.tasks.FunctionTask;
import flashbang.tasks.SerialTask;
import flashbang.tasks.TimedTask;

import org.osflash.signals.Signal;

import starling.events.Touch;

/**
 * A button base class. Abstract.
 */
public class Button extends SpriteObject
{
    /** Fired when the button is clicked */
    public const clicked :Signal = new Signal();

    public function get enabled () :Boolean {
        return (_state != DISABLED);
    }

    public function set enabled (val :Boolean) :void {
        if (val != this.enabled) {
            setState(val ? UP : DISABLED);
        }
    }

    /**
     * Simulates a click on the button. If it's not disabled, the button will fire the
     * clicked signal and show a short down-up animation.
     */
    public function click () :void {
        if (this.enabled) {
            this.clicked.dispatch();

            if (_state != DOWN) {
                addTask(new SerialTask(
                    new FunctionTask(function () :void { showState(DOWN); }),
                    new TimedTask(0.25),
                    new FunctionTask(function () :void { showState(_state); })));
            }
        }
    }

    /** Subclasses must override this to display the appropriate state */
    protected function showState (state :int) :void {
        throw new Error("abstract");
    }

    override protected function addedToMode () :void {
        showState(_state);

        var self :Button = this;
        _regs.addSignalListener(this.hoverBegan, function (t :Touch) :void {
            if (_state != DISABLED) {
                setState(OVER);
            }
        });
        _regs.addSignalListener(this.hoverEnded, function () :void {
            if (_state != DISABLED) {
                setState(UP);
            }
        });

        _regs.addSignalListener(this.touchBegan, function (touch :Touch) :void {
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

    protected function setState (val :int) :void {
        if (_state != val) {
            _state = val;
            if (_state == DISABLED) {
                cancelCapture();
            }
            showState(_state);
        }
    }

    protected function cancelCapture () :void {
        if (_captureReg != null) {
            _captureReg.cancel();
            _captureReg = null;
        }
    }

    protected function onPointerMove (touch :Touch) :void {
        _pointerOver = hitTest(touch);
        setState(_pointerOver ? DOWN : UP);
    }

    protected function onPointerEnd (touch :Touch) :void {
        setState(UP);
        cancelCapture();
        // emit the signal after doing everything else, because a signal handler could change
        // our state
        if (hitTest(touch)) {
            this.clicked.dispatch();
        }
    }

    protected function hitTest (touch :Touch) :Boolean {
        P.setTo(touch.globalX, touch.globalY);
        return (_sprite.hitTest(_sprite.globalToLocal(P, P), true) != null);
    }

    protected var _state :int = 0;
    protected var _pointerOver :Boolean;
    protected var _captureReg :Registration;

    protected static const UP :int = 0;
    protected static const DOWN :int = 1;
    protected static const OVER :int = 2;
    protected static const DISABLED :int = 3;

    protected static const P :Point = new Point();
}
}
