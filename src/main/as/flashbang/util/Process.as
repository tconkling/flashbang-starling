//
// aciv

package flashbang.util {

import react.Future;
import react.NumberView;

/** Enables observation of a process that will eventually complete */
public interface Process {
    /** Emits progress updates, which are values between [0, 1]. Progress never decreases. */
    function get progress () :NumberView;

    /** The process's result */
    function get result () :Future;
}
}
