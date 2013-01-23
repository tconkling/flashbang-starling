//
// Flashbang

package flashbang.tasks {

import flashbang.GameObject;
import flashbang.ObjectTask;

/**
 * A Task that calls a function. The function should take no arguments.
 * It may return either nothing, or a Boolean.
 * If the function returns a Boolean, it will be called on each update until it
 * returns false.
 */
public class FunctionTask
    implements ObjectTask
{
    public function FunctionTask (fn :Function)
    {
        _fn = fn;
    }

    public function update (dt :Number, obj :GameObject) :Boolean
    {
        // If Function returns "false", the FunctionTask will not complete.
        // Any other return value (including void) will cause it to complete immediately.
        return (_fn() !== false);
    }

    public function clone () :ObjectTask
    {
        return new FunctionTask(_fn);
    }

    protected var _fn :Function;
}

}
