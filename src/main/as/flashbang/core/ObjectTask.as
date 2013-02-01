//
// Flashbang

package flashbang.core {

public interface ObjectTask
{
    /**
     * Updates the ObjectTask.
     * Returns true if the task has completed, otherwise false.
     */
    function update (dt :Number, obj :GameObject) :Boolean;
}

}
