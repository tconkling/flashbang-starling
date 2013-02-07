//
// Flashbang

package flashbang.loader {

import aspire.util.Preconditions;

public class BatchLoader extends DataLoader
{
    /**
     * Creates a new BatchLoader.
     *
     * @param maxSimultaneous the number of DataLoaders that can be loading simultaneously
     * (or 0 for unlimited).
     */
    public function BatchLoader (maxSimultaneous :int = 0) {
        _maxSimultaneous = maxSimultaneous;
    }

    /** Adds a loader to the batch */
    public function addLoader (loader :DataLoader) :void {
        Preconditions.checkState(this.state == LoadState.INIT,
            "Batch is loading or loaded", "state", this.state);
        Preconditions.checkArgument(loader.state == LoadState.INIT,
            "Loader has already been loaded", "state", loader.state);
        _pending.push(loader);
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
            loadOne(_pending.shift());
        }
    }

    protected function loadOne (loader :DataLoader) :void {
        var self :BatchLoader = this;
        _loading.push(loader);
        loader.load(
            function () :void {
                // we may have gotten canceled
                if (self.state == LoadState.LOADING) {
                    removeFirst(_loading, loader);
                    _loaded.push(loader);
                    loadMore();
                }
            },
            function (e :Error) :void {
                // we may have gotten canceled
                if (self.state == LoadState.LOADING) {
                    removeFirst(_loading, loader);
                    onLoadCanceled();
                    fail(e);
                }
            });
    }

    override protected function onLoadCanceled () :void {
        for each (var loader :DataLoader in _loading) {
            loader.cancel();
        }

        cleanup();
    }

    protected function cleanup () :void {
        _pending = null;
        _loading = null;
        _loaded = null;
    }

    protected static function removeFirst (v :Vector.<DataLoader>, l :DataLoader) :void {
        var len :int = v.length;
        for (var ii :int = 0; ii < len; ++ii) {
            if (v[ii] == l) {
                v.splice(ii, 1);
                break;
            }
        }
    }

    protected var _maxSimultaneous :int;

    private var _pending :Vector.<DataLoader> = new <DataLoader>[];
    private var _loading :Vector.<DataLoader> = new <DataLoader>[];
    private var _loaded :Vector.<DataLoader> = new <DataLoader>[];
}
}
