//
// Flashbang

package flashbang.objects {

import flashbang.core.GameObject;
import flashbang.core.ObjectTask;
import flashbang.tasks.AnimateValueTask;
import flashbang.tasks.FunctionTask;
import flashbang.tasks.RepeatingTask;
import flashbang.tasks.SelfDestructTask;
import flashbang.tasks.SerialTask;
import flashbang.util.BoxedNumber;

public class SimpleTimer extends GameObject
{
    public function SimpleTimer (delay :Number, callback :Function = null,
        repeating :Boolean = false, timerName :String = null) {

        _name = timerName;
        _timeLeft.value = delay;

        if (repeating) {
            addTask(new RepeatingTask(function () :ObjectTask {
                var sequence :SerialTask = new SerialTask(
                    // init _timeLeft to delay
                    new AnimateValueTask(_timeLeft, delay, 0),
                    // animate _timeLeft to 0 over delay seconds
                    new AnimateValueTask(_timeLeft, 0, delay));
                if (null != callback) {
                    // call the callback
                    sequence.addTask(new FunctionTask(callback));
                }
                return sequence;
            }));

        } else {
            var serialTask :SerialTask = new SerialTask();

            // decrement _timeLeft to 0 over delay seconds
            serialTask.addTask(new AnimateValueTask(_timeLeft, 0, delay));

            if (null != callback) {
                // call the callback
                serialTask.addTask(new FunctionTask(callback));
            }

            // self-destruct when complete
            serialTask.addTask(new SelfDestructTask());

            addTask(serialTask);
        }
    }

    override public function get objectNames () :Array {
        return _name == null ? [] : [ _name ];
    }

    public function get timeLeft () :Number  {
        return _timeLeft.value;
    }

    protected var _name :String;
    protected var _timeLeft :BoxedNumber = new BoxedNumber();

}

}
