//
// aciv

package flashbang.util {

import react.NumberView;

public interface HasProgress {
    /** Emits progress updates, which are values between [0, 1]. Progress never decreases. */
    function get progress () :NumberView;
}
}
