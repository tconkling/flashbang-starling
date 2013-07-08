//
// Flashbang

package flashbang.loader {

import aspire.util.ClassUtil;
import aspire.util.Joiner;
import aspire.util.Log;
import aspire.util.Preconditions;

import flash.events.ErrorEvent;

import react.Registration;
import react.Signal;
import react.SignalView;

public class DataLoader
    implements Registration
{
    public function DataLoader () {
        _state = LoadState.INIT;
    }

    /** @return a Signal(result:*) that fires if and when the load succeeds */
    public final function get loaded () :SignalView {
        if (_loaded == null) {
            _loaded = new Signal(Object);
        }
        return _loaded;
    }

    /** @return a Signal(err:Error) that fires if and when the load fails */
    public final function get failed () :SignalView {
        if (_failed == null) {
            _failed = new Signal(Error);
        }
        return _failed;
    }

    /** @return a Signal(LoadState) that fires when the loader's state changes */
    public final function get stateChanged () :SignalView {
        if (_stateChanged == null) {
            _stateChanged = new Signal(LoadState);
        }
        return _stateChanged;
    }

    /** @return the Loader's LoadState */
    public final function get state () :LoadState {
        return _state;
    }

    public function get wasCanceled () :Boolean {
        return _state == LoadState.CANCELED;
    }

    /** Return the result of the load (if successful), or the load error (if the load failed) */
    public final function get result () :* {
        return _result;
    }

    /**
     * Loads the DataLoader.
     *
     * @param onLoaded (optional) a function to call if and when the load succeeds.
     * It should take 0 or 1 arguments. If it takes 1 argument, it will be passed
     * the result of the load.
     *
     * @param onLoadErr an optional Function to call if and when the load fails due to error.
     * It should take 0 or 1 arguments. If it takes 1 argument, it will be passed the
     * load Error object.
     */
    public final function load (onLoaded :Function = null, onLoadErr :Function = null) :void {
        Preconditions.checkState(_state == LoadState.INIT, "Can't load", "state", _state);

        _loadedCallback = onLoaded;
        _errorCallback = onLoadErr;
        setState(LoadState.LOADING);

        try {
            doLoad();
        } catch (e :Error) {
            fail(e);
        }
    }

    /** Cancels an in-progress load. */
    public final function close () :void {
        if (_state == LoadState.INIT || _state == LoadState.LOADING) {
            setState(LoadState.CANCELED);
            onCanceled();
        }
    }

    /** Subclasses must call this when they've successfully loaded */
    protected function succeed (result :* = undefined) :void {
        if (this.wasCanceled) {
            return;
        }

        Preconditions.checkState(_state == LoadState.LOADING, "not loading", "state", _state);

        _result = result;
        setState(LoadState.SUCCEEDED);

        try {
            if (_loadedCallback != null) {
                if (_loadedCallback.length == 0) {
                    _loadedCallback();
                } else {
                    _loadedCallback(_result);
                }
            }

            if (_loaded != null) {
                _loaded.emit(_result);
            }
        } catch (e :Error) {
            log.error("Error thrown in DataLoader.succeed callback", e);
        }
    }

    /**
     * Subclasses must call this if there's a load error.
     * Data pertaining to the failure (an Error object, an ErrorEvent, or anything else) should
     * be passed as the result. It will be coerced into an Error object and passed to the loader's
     * failure handlers.
     */
    protected function fail (result :* = undefined) :void {
        if (this.wasCanceled) {
            return;
        }

        Preconditions.checkState(_state == LoadState.LOADING, "not loading", "state", _state);

        _result = resultToError(result);
        setState(LoadState.FAILED);

        try {
            if (_errorCallback != null) {
                if (_errorCallback.length == 0) {
                    _errorCallback();
                } else {
                    _errorCallback(_result);
                }
            }

            if (_failed != null) {
                _failed.emit(_result);
            }
        } catch (ee :Error) {
            log.error("Error thrown in DataLoader.fail callback", ee);
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

    protected static function resultToError (result :*) :Error {
        if (result is Error) {
            return result;
        } else if (result is ErrorEvent) {
            var ee :ErrorEvent = result as ErrorEvent;
            return new Error(Joiner.pairs("An ErrorEvent occurred",
                "type", ClassUtil.tinyClassName(ee), "message", ee.text));
        } else {
            return new Error("An unknown failure occurred" +
                (result != null ? " (" + result + ")" : ""));
        }
    }

    private function setState (state :LoadState) :void {
        if (_state == state) {
            return;
        }
        _state = state;
        if (_stateChanged != null) {
            _stateChanged.emit(_state);
        }
    }

    // lazily instantiated
    private var _loaded :Signal;
    private var _failed :Signal;
    private var _stateChanged :Signal;

    private var _loadedCallback :Function;
    private var _errorCallback :Function;

    private var _state :LoadState;
    private var _result :* = undefined;

    protected static const log :Log = Log.getLog(DataLoader);
}

}
