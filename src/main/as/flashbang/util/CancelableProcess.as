//
// aciv

package flashbang.util {

import flashbang.util.Process;

public interface CancelableProcess extends Process {
    /**
     * Stops the load if it hasn't completed. `result` will fail with a CanceledError.
     * This is a no-op if the load has already completed.
     */
    function cancel () :void;
}

}
