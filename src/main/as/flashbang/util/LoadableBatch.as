//
// Flashbang

package flashbang.util {

import aspire.util.Preconditions;

public class LoadableBatch extends Loadable
{
    /**
     * Creates a new LoadableBatch.
     *
     * @param loadInSequence if true, loads all Loadables one by one (useful if there are
     * dependencies between the Loadables). Otherwise, loads all Loadables simultaneously.
     * Defaults to false.
     */
    public function LoadableBatch (loadInSequence :Boolean = false)
    {
        _loadInSequence = loadInSequence;
    }

    public function addLoadable (loadable :Loadable) :void
    {
        Preconditions.checkState(_state == STATE_NOT_LOADED, "Batch is loading or loaded");
        _allObjects.push(loadable);
    }

    override protected function doLoad () :void
    {
        // If we don't have any objects to load, we're done!
        if (_allObjects.length == 0) {
            succeed();
            return;
        }

        for each (var loadable :Loadable in _allObjects) {
            loadOneObject(loadable);
            // don't continue if the load operation has been canceled/errored,
            // or if we're loading in sequence
            if (_state != STATE_LOADING || _loadInSequence) {
                break;
            }
        }
    }

    protected function loadOneObject (loadable :Loadable) :void
    {
        loadable.load(function () :void { onObjectLoaded(loadable); }, fail);
    }

    override protected function doUnload () :void
    {
        for each (var loadable :Loadable in _allObjects) {
            loadable.unload();
        }

        _loadedObjects = [];
    }

    protected function onObjectLoaded (loadable :Loadable) :void
    {
        _loadedObjects.push(loadable);

        if (_loadedObjects.length == _allObjects.length) {
            // We finished loading
            succeed();
        } else if (_loadInSequence) {
            // We have more to load
            loadOneObject(_allObjects[_loadedObjects.length]);
        }
    }

    protected var _loadInSequence :Boolean;
    protected var _allObjects :Array = []; // Array<Loadable>
    protected var _loadedObjects :Array = []; // Array<Loadable>
}
}
