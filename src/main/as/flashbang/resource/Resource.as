//
// Flashbang

package flashbang.resource {

public class Resource
{
    public function Resource (name :String)
    {
        _name = name;
    }

    public final function get name () :String
    {
        return _name;
    }

    /** Subclasses can override this to implement unloading logic */
    protected function unload () :void
    {
    }

    internal function unloadInternal () :void
    {
        unload();
    }

    protected var _name :String;

    /** The set that this Resource belongs to */
    internal var _set :ResourceSet;
}

}
