//
// Flashbang

package flashbang.tasks {

import flashbang.core.ObjectTask;

/**
 * A Task that calls a function once and then completes.
 */
public class CallbackTask extends ObjectTask
{
    public function CallbackTask (f :Function) {
        _f = f;
    }

    override protected function added () :void {
        _f();
        destroySelf();
    }

    protected var _f :Function;
}

}
