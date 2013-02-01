//
// Flashbang

package flashbang.tasks {

import flashbang.core.GameObject;
import flashbang.core.ObjectTask;

/**
 * A Task that calls a function.
 * The function may take up to two arguments: (dt :Number, obj :GameObject).
 * It may return either nothing, or a Boolean.
 * If the function returns a Boolean, it will be called on each update until it
 * returns false.
 */
public class FunctionTask
    implements ObjectTask
{
    public function FunctionTask (fn :Function) {
        _fn = fn;
    }

    public function update (dt :Number, obj :GameObject) :Boolean {
        // If Function returns "false", the FunctionTask will not complete.
        // Any other return value (including void) will cause it to complete immediately.
        switch (_fn.length) {
        case 2: return (_fn(dt, obj) !== false);
        case 1: return (_fn(dt) !== false);
        default: return (_fn() !== false);
        }
    }

    protected var _fn :Function;
}

}
