//
// Flashbang

package flashbang.tasks {

import aspire.util.Preconditions;

import flashbang.core.ObjectTask;

public class ParallelTask extends ObjectTask
{
    public function ParallelTask (...tasks) {
        for each (var task :ObjectTask in tasks) {
            _subtasks.push(task);
        }
    }

    public function addTask (task :ObjectTask) :void {
        Preconditions.checkState(this.parent == null, "Can't modify a running ParallelTask");
        _subtasks.push(task);
    }

    override protected function added () :void {
        var numActive :uint = _subtasks.length;
        function taskComplete () :void {
            if (--numActive == 0) {
                destroySelf();
            }
        }

        for each (var task :ObjectTask in _subtasks) {
            this.regs.addSignalListener(task.destroyed, taskComplete);
            this.parent.addObject(task);
        }
    }

    override protected function removed () :void {
        for each (var task :ObjectTask in _subtasks) {
            task.destroySelf();
        }
    }

    protected var _subtasks :Vector.<ObjectTask> = new <ObjectTask>[];
}

}
