//
// aciv

package flashbang.resource {

import flashbang.util.Process;

public interface ResourceLoader extends Process {
    /**
     * The size of the resource to be loaded.
     * This is intended for progress bar updating, and therefore doesn't need to be an absolute
     * value, just relative to other resources in the game.
     */
    function get loadSize () :Number;
}
}
