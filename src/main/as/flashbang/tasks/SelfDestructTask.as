//
// Flashbang

package flashbang.tasks {

import flashbang.core.GameObject;
import flashbang.core.ObjectTask;

/**
 * A Task that destroys its parent.
 */
public class SelfDestructTask extends ObjectTask
{
    override protected function added() :void {
        GameObject(this.parent).destroySelf();
    }
}

}
