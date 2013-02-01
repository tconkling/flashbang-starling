//
// Flashbang

package flashbang.tasks {

public class SerialTask extends TaskContainer
{
    public function SerialTask (...subtasks) {
        super(TaskContainer.TYPE_SERIAL, subtasks);
    }
}

}
