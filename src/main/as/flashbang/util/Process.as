//
// aciv

package flashbang.util {

import react.Future;

/** Represents a process that will eventually complete */
public interface Process extends HasProgress {
    /**
     * The process's result. The behavior of calling `result` before `begin` has been called
     * is up to subclasses.
     */
    function get result () :Future;

    /**
     * Begins the process if it hasn't already begun. Returns `result` for convenience.
     * It is not an error to call this multiple times. If the process has already begun,
     * `begin` is a no-op that simply returns `result`.
     */
    function begin () :Future;
}
}
