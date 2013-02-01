//
// Flashbang

package flashbang.tasks {

import flashbang.core.GameObject;
import flashbang.core.ObjectTask;

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
