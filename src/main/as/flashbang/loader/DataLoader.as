//
// Flashbang

package flashbang.loader {

import aspire.util.Log;
import aspire.util.Preconditions;

import react.Promise;
import react.Registration;
import react.SignalView;
import react.UnitSignal;

public class DataLoader extends Promise
    implements Registration
{
    public function DataLoader () {
        _state = LoadState.INIT;
    }

    public final function get state () :LoadState {
        return _state;
    }

    public final function get canceled () :SignalView {
        if (_canceled == null) {
            _canceled = new UnitSignal();
        }
        return _canceled;
    }

    public final function get wasCanceled () :Boolean {
        return _state == LoadState.CANCELED;
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
        _state = LoadState.LOADING;

        try {
            doLoad();
        } catch (e :Error) {
            fail(e);
        }
        return this;
    }

    public final function close () :void {
        cancel();
    }

    /**
     * Cancels the DataLoader. If the DataLoader has already been canceled, has finished loading,
     * or is already in an error state, this will have no effect.
     */
    public final function cancel () :void {
        if (_state == LoadState.INIT || _state == LoadState.LOADING) {
            _state = LoadState.CANCELED;
            onCanceled();
            if (_canceled != null) {
                _canceled.emit();
            }
        }
    }

    override public function fail (cause :Object) :void {
        if (!this.wasCanceled) {
            _state = LoadState.FAILED;
            super.fail(cause);
        }
    }

    override public function succeed (value :Object = null) :void {
        if (!this.wasCanceled) {
            _state = LoadState.SUCCEEDED;
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

    private var _state :LoadState;
    private var _canceled :UnitSignal; // lazily-instantiated

    protected static const log :Log = Log.getLog(DataLoader);
}

}
