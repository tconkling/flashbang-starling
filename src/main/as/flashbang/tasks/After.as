//
// Flashbang

package flashbang.tasks {

import flashbang.core.ObjectTask;

public function After (duration :Number, task :ObjectTask) :ObjectTask
{
    return (duration > 0 ? new SerialTask(new TimedTask(duration), task) : task);
}

}
