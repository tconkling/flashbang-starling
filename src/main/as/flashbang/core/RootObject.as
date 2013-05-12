//
// flashbang

package flashbang.core {

internal class RootObject extends GameObject
{
    public function RootObject (mode :AppMode) {
        _mode = mode;
        _ref = new GameObjectRef();
        _ref._obj = this;
    }
}
}
