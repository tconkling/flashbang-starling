//
// Flashbang

package flashbang.util {

import aspire.util.Log;
import aspire.util.Preconditions;

public class Loadable
{
    public function get isLoaded () :Boolean
    {
        return _state == STATE_SUCCEEDED;
    }

    /** Return the result of the load (if successful), or the load error (if the load failed) */
    public function get result () :*
    {
        return _result;
    }

    public function load (onLoaded :Function = null, onLoadErr :Function = null) :void
    {
        Preconditions.checkState(_state != STATE_CANCELED, "canceled");

        if (_state == STATE_SUCCEEDED && onLoaded != null) {
            onLoaded();

        } else if (_state == STATE_FAILED && onLoadErr != null) {
            onLoadErr(_result);

        } else if (_state == STATE_NOT_LOADED || _state == STATE_LOADING) {
            if (onLoaded != null) {
                _onLoadedCallbacks.push(onLoaded);
            }
            if (onLoadErr != null) {
                _onLoadErrCallbacks.push(onLoadErr);
            }

            if (_state == STATE_NOT_LOADED) {
                _state = STATE_LOADING;
                try {
                    doLoad();
                } catch (e :Error) {
                    fail(e);
                }
            }
        }
    }

    public function cancel () :void
    {
        if (_state == STATE_LOADING) {
            onLoadCanceled();
        }
        _state = STATE_CANCELED;
    }

    protected function succeed (result :* = undefined) :void
    {
        Preconditions.checkState(_state == STATE_LOADING, "not loading");

        _result = result;
        var callbacks :Array = _onLoadedCallbacks;

        _onLoadedCallbacks = [];
        _onLoadErrCallbacks = [];
        _state = STATE_SUCCEEDED;

        for each (var callback :Function in callbacks) {
            callback();
        }
    }

    protected function fail (e :Error) :void
    {
        Preconditions.checkState(_state == STATE_LOADING, "not loading");

        _result = e;
        _state = STATE_FAILED;
        var callbacks :Array = _onLoadErrCallbacks;
        for each (var callback :Function in callbacks) {
            callback(e);
        }
    }

    /**
     * Subclasses may override this to respond to the canceling of an in-progress load.
     */
    protected function onLoadCanceled () :void
    {
    }

    /**
     * Subclasses must override this to perform the load.
     * If the load is successful, this function should call succeed(), otherwise it should
     * call fail().
     */
    protected function doLoad () :void
    {
        throw new Error("abstract");
    }

    protected var _onLoadedCallbacks :Array = [];
    protected var _onLoadErrCallbacks :Array = [];

    protected var _state :int = 0;
    protected var _result :* = undefined;

    protected static const log :Log = Log.getLog(Loadable);

    protected static const STATE_NOT_LOADED :int = 0;
    protected static const STATE_LOADING :int = 1;
    protected static const STATE_SUCCEEDED :int = 2;
    protected static const STATE_FAILED :int = 3;
    protected static const STATE_CANCELED :int = 4;
}

}
