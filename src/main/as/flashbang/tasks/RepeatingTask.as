//
// Flashbang

package flashbang.tasks {

public class RepeatingTask extends TaskContainer
{
    public function RepeatingTask (...subtasks)
    {
        super(TaskContainer.TYPE_REPEATING, subtasks);
    }
}

}
