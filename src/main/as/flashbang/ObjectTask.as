//
// Flashbang

package flashbang {

public interface ObjectTask
{
    /**
     * Updates the ObjectTask.
     * Returns true if the task has completed, otherwise false.
     */
    function update (dt :Number, obj :GameObject) :Boolean;

    /** Returns a copy of the ObjectTask */
    function clone () :ObjectTask;
}

}
