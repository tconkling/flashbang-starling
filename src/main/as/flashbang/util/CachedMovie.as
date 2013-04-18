//
// Flashbang

package flashbang.util {

import aspire.util.Registration;

import flump.display.Movie;

/**
 * A movie taken from a MovieCache.
 * It can be 'canceled' via the Registration interface. (Canceling just calls through
 * to release()).
 */
public interface CachedMovie extends Registration
{
    /** Releases the Movie to the cache. */
    function release () :void;

    /** The movie */
    function get movie () :Movie;
}

}
