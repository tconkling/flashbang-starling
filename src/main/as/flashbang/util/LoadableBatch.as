//
// Flashbang

package flashbang.util {

import aspire.util.Arrays;
import aspire.util.Preconditions;

public class LoadableBatch extends Loadable
{
    /**
     * Creates a new LoadableBatch.
     *
     * @param maxSimultaneous the number of Loadables that can be loading simultaneously
     * (or 0 for unlimited).
     */
    public function LoadableBatch (maxSimultaneous :int = 0)
    {
        _maxSimultaneous = maxSimultaneous;
    }

    public function addLoadable (loadable :Loadable) :void
    {
        Preconditions.checkState(_state == STATE_NOT_LOADED, "Batch is loading or loaded");
        _pending.push(loadable);
    }

    override protected function doLoad () :void
    {
        loadMore();
    }

    protected function loadMore () :void
    {
        // If we don't have any objects to load, we're done!
        if (_pending.length == 0 && _loading.length == 0) {
            succeed(_loaded);
            cleanup();
            return;
        }

        while (_pending.length > 0 &&
               _state == STATE_LOADING &&
               (_maxSimultaneous <= 0 || _loading.length < _maxSimultaneous)) {
            loadOneObject(_pending.shift());
        }
    }

    protected function loadOneObject (loadable :Loadable) :void
    {
        _loading.push(loadable);
        loadable.load(
            function () :void {
                // we may have gotten canceled
                if (_state == STATE_LOADING) {
                    Arrays.removeFirst(_loading, loadable);
                    _loaded.push(loadable);
                    loadMore();
                }
            },
            function (e :Error) :void {
                // we may have gotten canceled
                if (_state == STATE_LOADING) {
                    onLoadCanceled();
                    fail(e);
                }
            });
    }

    override protected function onLoadCanceled () :void
    {
        for each (var loadable :Loadable in _loading) {
            loadable.cancel();
        }

        cleanup();
    }

    protected function cleanup () :void
    {
        _pending = null;
        _loading = null;
        _loaded = null;
    }

    protected var _maxSimultaneous :int;

    private var _pending :Array = [];
    private var _loading :Array = [];
    private var _loaded :Array = [];
}
}
