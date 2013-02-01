//
// Flashbang

package flashbang.util {

import aspire.util.Preconditions;

public class LoadableBatch extends Loadable
{
    /**
     * Creates a new LoadableBatch.
     *
     * @param maxSimultaneous the number of Loadables that can be loading simultaneously
     * (or 0 for unlimited).
     */
    public function LoadableBatch (maxSimultaneous :int = 0) {
        _maxSimultaneous = maxSimultaneous;
    }

    /** Adds a Loadable to the batch */
    public function addLoadable (loadable :Loadable) :void {
        Preconditions.checkState(this.state == LoadState.INIT,
            "Batch is loading or loaded", "state", this.state);
        Preconditions.checkArgument(loadable.state == LoadState.INIT,
            "Loadable has already been loaded", "state", loadable.state);
        _pending.push(loadable);
    }

    override protected function doLoad () :void {
        loadMore();
    }

    protected function loadMore () :void {
        // If we don't have any objects to load, we're done!
        if (_pending.length == 0 && _loading.length == 0) {
            succeed(_loaded);
            cleanup();
            return;
        }

        while (this.state == LoadState.LOADING &&
               _pending.length > 0 &&
               (_maxSimultaneous <= 0 || _loading.length < _maxSimultaneous)) {
            loadOneObject(_pending.shift());
        }
    }

    protected function loadOneObject (loadable :Loadable) :void {
        var self :LoadableBatch = this;
        _loading.push(loadable);
        loadable.load(
            function () :void {
                // we may have gotten canceled
                if (self.state == LoadState.LOADING) {
                    removeFirst(_loading, loadable);
                    _loaded.push(loadable);
                    loadMore();
                }
            },
            function (e :Error) :void {
                // we may have gotten canceled
                if (self.state == LoadState.LOADING) {
                    removeFirst(_loading, loadable);
                    onLoadCanceled();
                    fail(e);
                }
            });
    }

    override protected function onLoadCanceled () :void {
        for each (var loadable :Loadable in _loading) {
            loadable.cancel();
        }

        cleanup();
    }

    protected function cleanup () :void {
        _pending = null;
        _loading = null;
        _loaded = null;
    }

    protected static function removeFirst (v :Vector.<Loadable>, l :Loadable) :void {
        var len :int = v.length;
        for (var ii :int = 0; ii < len; ++ii) {
            if (v[ii] == l) {
                v.splice(ii, 1);
                break;
            }
        }
    }

    protected var _maxSimultaneous :int;

    private var _pending :Vector.<Loadable> = new <Loadable>[];
    private var _loading :Vector.<Loadable> = new <Loadable>[];
    private var _loaded :Vector.<Loadable> = new <Loadable>[];
}
}
