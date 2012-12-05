//
// Flashbang

package flashbang.objects {

import flashbang.GameObject;
import flashbang.tasks.*;
import flashbang.util.BoxedNumber;

public class SimpleTimer extends GameObject
{
    public function SimpleTimer (delay :Number, callback :Function = null,
        repeating :Boolean = false, timerName :String = null)
    {
        _name = timerName;
        _timeLeft.value = delay;

        if (repeating) {
            var repeatingTask :RepeatingTask = new RepeatingTask();

            // init _timeLeft to delay
            repeatingTask.addTask(new AnimateValueTask(_timeLeft, delay, 0));

            // animate _timeLeft to 0 over delay seconds
            repeatingTask.addTask(new AnimateValueTask(_timeLeft, 0, delay));

            if (null != callback) {
                // call the callback
                repeatingTask.addTask(new FunctionTask(callback));
            }

            addTask(repeatingTask);

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

    override public function get objectNames () :Array
    {
        return _name == null ? [] : [ _name ];
    }

    public function get timeLeft () :Number
    {
        return _timeLeft.value;
    }

    protected var _name :String;
    protected var _timeLeft :BoxedNumber = new BoxedNumber();

}

}
