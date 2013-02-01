//
// Flashbang

package flashbang.resource {

public class Resource
{
    public function Resource (name :String) {
        _name = name;
    }

    public final function get name () :String {
        return _name;
    }

    /** Return true if the Resource is still loaded. It's an error to use unloaded resources. */
    public final function get isLoaded () :Boolean {
        return !_unloaded;
    }

    /** Subclasses can override this to implement unloading logic */
    protected function unload () :void {
    }

    internal function unloadInternal () :void {
        if (!_unloaded) {
            _unloaded = true;
            unload();
        }
    }

    protected var _name :String;
    protected var _unloaded :Boolean;

    /** The set that this Resource belongs to */
    internal var _set :ResourceSet;
}

}
