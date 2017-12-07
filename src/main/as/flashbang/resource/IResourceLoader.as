//
// aciv

package flashbang.resource {

import flashbang.loader.LoadProcess;

import react.Future;

public interface IResourceLoader extends LoadProcess {
    /**
     * The size of the resource to be loaded.
     * This is intended for progress bar updating, and therefore doesn't need to be an absolute
     * value, just relative to other resources in the game.
     */
    function get loadSize () :Number;

    /**
     * Starts the loading process.
     * LoadProcess.result should resolve with the Resources to be added to the ResourceManager.
     *
     * @return LoadProcess.result
     */
    function load () :Future;
}
}
