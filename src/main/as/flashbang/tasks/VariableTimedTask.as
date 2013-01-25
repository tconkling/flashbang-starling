//
// Flashbang

package flashbang.tasks {

import aspire.util.Randoms;

import flashbang.core.GameObject;
import flashbang.core.ObjectTask;

public class VariableTimedTask
    implements ObjectTask
{
    public function VariableTimedTask (timeLo :Number, timeHi :Number, rands :Randoms)
    {
        _timeLo = timeLo;
        _timeHi = timeHi;
        _rands = rands;

        _time = _rands.getNumberInRange(timeLo, timeHi);
    }

    public function update (dt :Number, obj :GameObject) :Boolean
    {
        _elapsedTime += dt;

        return (_elapsedTime >= _time);
    }

    public function clone () :ObjectTask
    {
        return new VariableTimedTask(_timeLo, _timeHi, _rands);
    }

    protected var _timeLo :Number;
    protected var _timeHi :Number;
    protected var _rands :Randoms;
    protected var _time :Number = 0;
    protected var _elapsedTime :Number = 0;
}

}
