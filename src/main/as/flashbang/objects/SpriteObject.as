//
// Flashbang

package flashbang.objects {

import starling.display.Sprite;

/**
 * A SceneObject that creates and manages a Sprite as its displayObject.
 */
public class SpriteObject extends SceneObject
{
    public function SpriteObject (name :String = null, group :String = null) {
        super(new Sprite(), name, group);
        _sprite = Sprite(_displayObject);
    }

    public function get sprite () :Sprite {
        return _sprite;
    }

    protected var _sprite :Sprite;
}
}
