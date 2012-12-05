//
// Flashbang

package flashbang.tasks {

import flashbang.GameObject;
import flashbang.ObjectTask;

public class FunctionTask
    implements ObjectTask
{
    public function FunctionTask (fn :Function, ...args)
    {
        if (null == fn) {
            throw new ArgumentError("fn must be non-null");
        }

        _fn = fn;
        _args = args;
    }

    public function update (dt :Number, obj :GameObject) :Boolean
    {
        // If Function returns "false", the FunctionTask will not complete.
        // Any other return value (including void) will cause it to complete immediately.
        return (_fn.apply(null, _args) !== false);
    }

    public function clone () :ObjectTask
    {
        var task :FunctionTask = new FunctionTask(_fn);
        // Work around for the pain associated with passing a normal Array as a varargs Array
        task._args = _args;
        return task;
    }

    protected var _fn :Function;
    protected var _args :Array;
}

}
