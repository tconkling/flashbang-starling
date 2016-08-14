//
// aciv

package flashbang.audio {

import flashbang.resource.SoundResource;

public interface SoundSet {
    /** @return the next sound that should be played in the set. Can return null for no sound. */
    function nextSound () :SoundResource;
}
}
