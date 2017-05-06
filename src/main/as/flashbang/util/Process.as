//
// aciv

package flashbang.util {

import react.NumberView;

/** Enables observation of a process that will eventually complete */
public interface Process {
    /**
     * The "size" of the process being observed. This is a relative value that indicates
     * how long the process will take to load in relation to other processes being observed in
     * a BatchProcess.
     */
    function get processSize () :Number;

    /** Emits progress updates, which are values between [0, 1]. Progress never decreases. */
    function get progress () :NumberView;
}
}
