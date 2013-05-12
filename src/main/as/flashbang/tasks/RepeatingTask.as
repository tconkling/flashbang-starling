//
// Flashbang

package flashbang.tasks {

import flashbang.core.ObjectTask;

/**
 * A Task that repeats.
 *
 * @param taskCreator a function that takes 0 parameters and returns an ObjectTask, or null.
 * When the RepeatingTask completes its task, it will call taskCreator to regenerate the task.
 * If taskCreator returns null, the RepeatingTask will complete; else it will keep running.
 */
public class RepeatingTask extends ObjectTask
{
    public function RepeatingTask (taskCreator :Function) {
        _taskCreator = taskCreator;
    }

    override protected function added () :void {
        restart();
    }

    override protected function removed () :void {
        if (_curTask != null) {
            _curTask.destroySelf();
            _curTask = null;
        }
    }

    protected function restart () :void {
        if (!this.isLiveObject || !this.parent.isLiveObject) {
            return;
        }

        _curTask = _taskCreator();
        if (_curTask == null) {
            destroySelf();
            return;
        }
        this.regs.addSignalListener(_curTask.destroyed, restart);
        this.parent.addObject(_curTask);
    }

    protected var _taskCreator :Function;
    protected var _curTask :ObjectTask;
}

}
