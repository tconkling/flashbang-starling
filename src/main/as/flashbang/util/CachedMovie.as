//
// Flashbang

package flashbang.util {

import flump.display.Movie;

import react.Registration;

/**
 * A movie taken from a MovieCache.
 * It can be 'canceled' via the Registration interface. (Canceling just calls through
 * to release()).
 */
public interface CachedMovie extends Registration
{
    /** Releases the Movie to the cache. Also detaches it from its parent, if it has one. */
    function release () :void;

    /** The movie */
    function get movie () :Movie;
}

}
