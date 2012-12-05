//
// Flashbang

package flashbang.tasks {

import flashbang.GameObject;
import flashbang.ObjectTask;

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
