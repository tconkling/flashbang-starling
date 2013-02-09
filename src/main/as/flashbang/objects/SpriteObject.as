//
// Flashbang

package flashbang.objects {

import starling.display.Sprite;

/**
 * A SceneObject that manages a Sprite as its displayObject.
 */
public class SpriteObject extends SceneObject
{
    public function SpriteObject (sprite :Sprite = null, id :Object = null, group :Object = null) {
        super(sprite || new Sprite(), id, group);
        _sprite = Sprite(_displayObject);
    }

    public function get sprite () :Sprite {
        return _sprite;
    }

    protected var _sprite :Sprite;
}
}
