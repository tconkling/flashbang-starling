//
// Flashbang

package flashbang.loader {

import aspire.util.Log;
import aspire.util.Preconditions;

import react.Promise;
import react.Registration;
import react.Signal;
import react.SignalView;

public class DataLoader extends Promise
    implements Registration
{
    public function DataLoader () {
        _state = LoadState.INIT;
    }

    public final function get state () :LoadState {
        return _state;
    }

    public final function get wasCanceled () :Boolean {
        return _state == LoadState.CANCELED;
    }

    public final function get stateChanged () :SignalView {
        return _stateChanged;
    }

    /**
     * Returns the value associated with a successful load, or rethrows the exception if the load
     * failed.
     */
    public function get result () :* {
        return _value.value.value;
    }

    /** Kicks off the loading process. @return this DataLoader, for chaining */
    public final function load () :DataLoader {
        Preconditions.checkState(_state == LoadState.INIT, "Can't load", "state", _state);
        setState(LoadState.LOADING);

        try {
            doLoad();
        } catch (e :Error) {
            fail(e);
        }
        return this;
    }

    /** Cancels an in-progress load. */
    public final function close () :void {
        if (_state == LoadState.INIT || _state == LoadState.LOADING) {
            setState(LoadState.CANCELED);
            onCanceled();
        }
    }

    override public function fail (cause :Object) :void {
        if (!this.wasCanceled) {
            setState(LoadState.FAILED);
            super.fail(cause);
        }
    }

    override public function succeed (value :Object = null) :void {
        if (!this.wasCanceled) {
            setState(LoadState.SUCCEEDED);
            super.succeed(value);
        }
    }

    /**
     * Subclasses may override this to respond to the canceling of an in-progress load.
     * This may also be called if a load is canceled before it has begun loading.
     */
    protected function onCanceled () :void {
    }

    /**
     * Subclasses must override this to perform the load.
     * If the load is successful, this function should call succeed(), otherwise it should
     * call fail().
     */
    protected function doLoad () :void {
        throw new Error("abstract");
    }

    protected function setState (state :LoadState) :void {
        if (_state != state) {
            _state = state;
            if (_stateChanged != null) {
                _stateChanged.emit(state);
            }
        }
    }

    protected var _state :LoadState;
    protected var _stateChanged :Signal; // lazily instantiated

    protected static const log :Log = Log.getLog(DataLoader);
}

}
