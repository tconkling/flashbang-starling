//
// aciv

package flashbang.loader {

import flashbang.util.Process;

import react.Future;

public interface LoadProcess extends Process {
    function get result () :Future;

    /**
     * Stops the load if it hasn't completed. `result` will fail with a CanceledError.
     * This is a no-op if the load has already completed.
     */
    function cancel () :void;
}

}
