//
// Flashbang

package flashbang.tasks {

import aspire.util.Arrays;
import aspire.util.Preconditions;

import flashbang.core.GameObject;
import flashbang.core.ObjectTask;

public class TaskContainer
    implements ObjectTask
{
    public function TaskContainer (type :uint, subtasks :Array = null)
    {
        if (type >= TYPE__LIMIT) {
            throw new ArgumentError("invalid 'type' parameter");
        }

        _type = type;

        if (subtasks != null) {
            for each (var task :ObjectTask in subtasks) {
                addTask(task);
            }
        }
    }

    /** Adds a child task to the TaskContainer. */
    public function addTask (task :ObjectTask, ...moreTasks) :void
    {
        if (null == task) {
            throw new ArgumentError("task must be non-null");
        }

        _tasks.push(task);
        _completedTasks.push(null);
        _activeTaskCount += 1;

        for each (var task :ObjectTask in moreTasks) {
            addTask(task);
        }
    }

    /** Removes all tasks from the TaskContainer. */
    public function removeAllTasks () :void
    {
        _invalidated = true;
        _tasks.length = 0;
        _completedTasks.length = 0;
        _activeTaskCount = 0;
    }

    /** Returns true if the TaskContainer has any child tasks. */
    public function hasTasks () :Boolean
    {
        return (_activeTaskCount > 0);
    }

    public function update (dt :Number, obj :GameObject) :Boolean
    {
        _invalidated = false;

        var n :int = _tasks.length;
        for (var ii :int = 0; ii < n; ++ii) {

            var task :ObjectTask = (_tasks[ii] as ObjectTask);

            // we can have holes in the array
            if (null == task) {
                continue;
            }

            var complete :Boolean = task.update(dt, obj);

            if (_invalidated) {
                // The TaskContainer was destroyed by its containing
                // GameObject during task iteration. Stop processing immediately.
                return false;
            }

            if (!complete && TYPE_PARALLEL != _type) {
                // Serial and Repeating tasks proceed one task at a time
                break;

            } else if (complete) {
                // the task is complete - move it the completed tasks array
                _completedTasks[ii] = _tasks[ii];
                _tasks[ii] = null;
                _activeTaskCount -= 1;
            }
        }

        // if this is a repeating task and all its tasks have been completed, start over again
        if (_type == TYPE_REPEATING && 0 == _activeTaskCount && _completedTasks.length > 0) {
            var completedTasks :Vector.<ObjectTask> = _completedTasks;

            _tasks = new <ObjectTask>[];
            _completedTasks = new <ObjectTask>[];

            for each (var completedTask :ObjectTask in completedTasks) {
                addTask(completedTask.clone());
            }
        }

        // once we have no more active tasks, we're complete
        return (0 == _activeTaskCount);
    }

    /** Returns a clone of the TaskContainer. */
    public function clone () :ObjectTask
    {
        var clonedSubtasks :Vector.<ObjectTask> = cloneSubtasks();
        var emptyTasks :Vector.<ObjectTask> = new Vector.<ObjectTask>(cloneSubtasks.length);
        for (var ii :int = 0; ii < cloneSubtasks.length; ++ii) {
            emptyTasks.push(null);
        }

        var theClone :TaskContainer = new TaskContainer(_type);
        theClone._tasks = clonedSubtasks;
        theClone._completedTasks = emptyTasks;
        theClone._activeTaskCount = clonedSubtasks.length;

        return theClone;
    }

    protected function cloneSubtasks () :Vector.<ObjectTask>
    {
        Preconditions.checkState(_tasks.length == _completedTasks.length);

        var out :Vector.<ObjectTask> = new Vector.<ObjectTask>(_tasks.length);

        // clone each child task and put it in the cloned container
        var n :int = _tasks.length;
        for (var ii :int = 0; ii < n; ++ii) {
            var task :ObjectTask = (null != _tasks[ii] ? _tasks[ii] : _completedTasks[ii]);
            Preconditions.checkNotNull(task);
            out[ii] = task.clone();
        }

        return out;
    }

    protected var _type :int;
    protected var _tasks :Vector.<ObjectTask> = new <ObjectTask>[];
    protected var _completedTasks :Vector.<ObjectTask> = new <ObjectTask>[];
    protected var _activeTaskCount :int;
    protected var _invalidated :Boolean;

    protected static const TYPE_PARALLEL :uint = 0;
    protected static const TYPE_SERIAL :uint = 1;
    protected static const TYPE_REPEATING :uint = 2;
    protected static const TYPE__LIMIT :uint = 3;
}

}
