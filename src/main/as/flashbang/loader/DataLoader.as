//
// Flashbang

package flashbang.loader {

import aspire.util.Log;
import aspire.util.Preconditions;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

public class DataLoader
{
    public function DataLoader () {
        _state = LoadState.INIT;
    }

    /** @return a Signal(result:*) that fires if and when the load succeeds */
    public final function get loaded () :ISignal {
        if (_loaded == null) {
            _loaded = new Signal(Object);
        }
        return _loaded;
    }

    /** @return a Signal(err:Error) that fires if and when the load fails */
    public final function get failed () :ISignal {
        if (_failed == null) {
            _failed = new Signal(Error);
        }
        return _failed;
    }

    /** @return the Loader's LoadState */
    public final function get state () :LoadState {
        return _state;
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
        _state = LoadState.LOADING;

        try {
            doLoad();
        } catch (e :Error) {
            fail(e);
        }
    }

    /** Cancels an in-progress load */
    public final function cancel () :void {
        Preconditions.checkState(_state == LoadState.LOADING, "not loading", "state", _state);
        _state = LoadState.CANCELED;
        onLoadCanceled();
    }

    /** Subclasses must call this when they've successfully loaded */
    protected function succeed (result :* = undefined) :void {
        if (_state == LoadState.CANCELED) {
            return;
        }

        Preconditions.checkState(_state == LoadState.LOADING, "not loading", "state", _state);

        _result = result;
        _state = LoadState.SUCCEEDED;

        if (_loadedCallback != null) {
            if (_loadedCallback.length == 0) {
                _loadedCallback();
            } else {
                _loadedCallback(_result);
            }
        }

        if (_loaded != null) {
            _loaded.dispatch(_result);
        }
    }

    /** Subclasses must call this if there's a load error */
    protected function fail (e :Error) :void {
        if (_state == LoadState.CANCELED) {
            return;
        }

        Preconditions.checkState(_state == LoadState.LOADING, "not loading", "state", _state);

        _result = e;
        _state = LoadState.FAILED;

        if (_errorCallback != null) {
            if (_errorCallback.length == 0) {
                _errorCallback();
            } else {
                _errorCallback(e);
            }
        }

        if (_failed != null) {
            _failed.dispatch(e);
        }
    }

    /**
     * Subclasses may override this to respond to the canceling of an in-progress load.
     */
    protected function onLoadCanceled () :void {
    }

    /**
     * Subclasses must override this to perform the load.
     * If the load is successful, this function should call succeed(), otherwise it should
     * call fail().
     */
    protected function doLoad () :void {
        throw new Error("abstract");
    }

    // lazily instantiated
    private var _loaded :Signal;
    private var _failed :Signal;

    private var _loadedCallback :Function;
    private var _errorCallback :Function;

    private var _state :LoadState = LoadState.INIT;
    private var _result :* = undefined;

    protected static const log :Log = Log.getLog(DataLoader);
}

}
