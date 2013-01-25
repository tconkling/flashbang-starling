//
// Flashbang

package flashbang.tasks {

import flashbang.core.GameObject;
import flashbang.core.ObjectTask;

public class SelfDestructTask
    implements ObjectTask
{
    public function update (dt :Number, obj :GameObject) :Boolean
    {
        obj.destroySelf();
        return true;
    }

    public function clone () :ObjectTask
    {
        return new SelfDestructTask();
    }
}

}
