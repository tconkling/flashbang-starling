//
// Flashbang

package flashbang.tasks {

import flashbang.core.GameObject;
import flashbang.core.ObjectTask;

/**
 * A Task that repeats.
 *
 * @param taskCreator a function that takes 0 parameters and returns an ObjectTask, or null.
 * When the RepeatingTask completes its task, it will call taskCreator to regenerate the task.
 * If taskCreator returns null, the RepeatingTask will complete; else it will keep running.
 */
public class RepeatingTask
    implements ObjectTask
{
    public function RepeatingTask (taskCreator :Function) {
        _taskCreator = taskCreator;
    }

    public function update (dt :Number, obj :GameObject) :Boolean {
        if (_curTask == null) {
            _curTask = _taskCreator();
            if (_curTask == null) {
                return true;
            }
        }

        if (_curTask.update(dt, obj)) {
            _curTask = null;
        }

        return false;
    }

    protected var _taskCreator :Function;
    protected var _curTask :ObjectTask;
}

}
