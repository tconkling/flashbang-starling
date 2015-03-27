//
// Flashbang

package flashbang.tasks {

import aspire.util.Preconditions;

import flashbang.core.ObjectTask;

public class SerialTask extends ObjectTask
{
    public function SerialTask (...tasks) {
        for each (var task :ObjectTask in tasks) {
            _subtasks.push(task);
        }
    }

    public function get numSubtasks () :uint {
        return _subtasks.length;
    }

    public function addTask (task :ObjectTask) :void {
        Preconditions.checkState(this.parent == null, "Can't modify a running SerialTask");
        _subtasks.push(task);
    }

    override protected function added () :void {
        nextTask();
    }

    protected function nextTask () :void {
        if (!this.isLiveObject || !this.parent.isLiveObject) {
            return;
        }

        if (_nextIdx < _subtasks.length) {
            var newTask :ObjectTask = _subtasks[_nextIdx++];
            this.regs.add(newTask.destroyed.connect(nextTask));
            this.parent.addObject(newTask);
        } else {
            destroySelf();
        }
    }

    override protected function removed () :void {
        if (_subtasks.length > 0 && _nextIdx <= _subtasks.length) {
            // destroy the active task
            _subtasks[_nextIdx - 1].destroySelf();
        }
    }

    protected var _subtasks :Vector.<ObjectTask> = new <ObjectTask>[];
    protected var _nextIdx :uint;
}

}
