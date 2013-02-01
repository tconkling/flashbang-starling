//
// Flashbang

package flashbang.tasks {

public class ParallelTask extends TaskContainer
{
    public function ParallelTask (...subtasks) {
        super(TaskContainer.TYPE_PARALLEL, subtasks);
    }
}

}
