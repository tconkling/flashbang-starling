//
// aciv

package flashbang.resource {

import flashbang.util.HasProcessSize;
import flashbang.util.Process;

import react.Executor;

public interface ResourceLoader extends Process, HasProcessSize {
    /**
     * Sets an Executor for the ResourceLoader to use.
     * ResourceLoaders that load files should pass those load processes through
     * the executor.
     */
    function executor (exec :Executor) :void;
}
}
