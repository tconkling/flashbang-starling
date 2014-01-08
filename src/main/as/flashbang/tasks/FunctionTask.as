//
// Flashbang

package flashbang.tasks {

import flashbang.core.ObjectTask;
import flashbang.core.Updatable;

/**
 * A Task that calls a function repeatedly.
 * The function may take up to two arguments: (dt :Number, obj :GameObject).
 * The function will be called until it returns false.
 */
public class FunctionTask extends ObjectTask
    implements Updatable
{
    public function FunctionTask (fn :Function) {
        _fn = fn;
    }

    public function update (dt :Number) :void {
        // If Function returns "false", the FunctionTask will not complete.
        // Any other return value (including void) will cause it to complete immediately.
        var complete :Boolean;
        switch (_fn.length) {
        case 2:
            complete = (_fn(dt, this.parent) !== false);
            break;
        case 1:
            complete = (_fn(dt) !== false);
            break;
        default:
            complete = (_fn() !== false);
            break;
        }

        if (complete) {
            destroySelf();
        }
    }

    protected var _fn :Function;
}

}
