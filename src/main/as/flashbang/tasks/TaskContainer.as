//
// Flashbang

package flashbang.tasks {

import aspire.util.Preconditions;

import flashbang.core.GameObject;
import flashbang.core.ObjectTask;

public class TaskContainer
    implements ObjectTask
{
    public function TaskContainer (type :uint, subtasks :Array = null) {
        Preconditions.checkArgument(type < TYPE__LIMIT, "invalid 'type' parameter", "type", type);
        _type = type;

        if (subtasks != null) {
            for each (var task :ObjectTask in subtasks) {
                addTask(task);
            }
        }
    }

    /** Adds a child task to the TaskContainer. */
    public function addTask (task :ObjectTask, ...moreTasks) :void {
        Preconditions.checkArgument(task != null, "Task can't be null");
        _tasks.push(task);
        for each (var task :ObjectTask in moreTasks) {
            addTask(task);
        }
    }

    /** Removes all tasks from the TaskContainer. */
    public function removeAllTasks () :void {
        _invalidated = true;
        _tasks.length = 0;
    }

    /** Returns true if the TaskContainer has any child tasks. */
    public function hasTasks () :Boolean {
        return _tasks.length > 0;
    }

    public function update (dt :Number, obj :GameObject) :Boolean {
        _invalidated = false;

        for (var ii :int = 0; ii < _tasks.length; ++ii) {
            var task :ObjectTask = _tasks[ii];
            var complete :Boolean = task.update(dt, obj);

            if (_invalidated) {
                // The TaskContainer was destroyed by its containing
                // GameObject during task iteration. Stop processing immediately.
                return false;
            }

            if (!complete && TYPE_PARALLEL != _type) {
                // Serial tasks proceed one task at a time
                break;

            } else if (complete) {
                // the task is complete; get rid of it
                --ii;
                _tasks.shift();
            }
        }

        return (_tasks.length == 0);
    }

    protected var _type :int;
    protected var _tasks :Vector.<ObjectTask> = new <ObjectTask>[];
    protected var _invalidated :Boolean;

    protected static const TYPE_PARALLEL :uint = 0;
    protected static const TYPE_SERIAL :uint = 1;
    protected static const TYPE__LIMIT :uint = 3;
}

}
