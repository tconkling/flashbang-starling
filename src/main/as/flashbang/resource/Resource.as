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
        return !_disposed;
    }

    /** Subclasses can override this perform custom registration logic when added to the ResourceManager */
    protected function added () :void {
    }

    /** Subclasses can override this to implement unloading logic */
    protected function dispose () :void {
    }

    internal function addedInternal (parent :ResourceSet) :void {
        _set = parent;
        added();
    }

    internal function disposeInternal () :void {
        if (!_disposed) {
            _disposed = true;
            dispose();
        }
    }

    protected var _name :String;
    protected var _disposed :Boolean;

    /** The set that this Resource belongs to */
    internal var _set :ResourceSet;
}

}
