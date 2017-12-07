//
// aciv

package flashbang.resource {

import flashbang.util.Process;

import react.Future;

public interface IResourceLoader extends Process {
    /**
     * The size of the resource to be loaded.
     * This is intended for progress bar updating, and therefore doesn't need to be an absolute
     * value, just relative to other resources in the game.
     */
    function get loadSize () :Number;

    /**
     * Starts the loading process.
     * CancelableProcess.result should resolve with the Resources to be added to the ResourceManager.
     *
     * @return Process.result
     */
    function load () :Future;
}
}
