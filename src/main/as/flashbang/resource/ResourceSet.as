//
// Flashbang

package flashbang.resource {

import aspire.util.Log;

import flashbang.Flashbang;
import flashbang.util.Loadable;
import flashbang.util.LoadableBatch;

public class ResourceSet extends LoadableBatch
{
    public function ResourceSet (loadInSequence :Boolean = false)
    {
        super(loadInSequence);
    }

    public function addResource (type :String, name: String, loadParams :*) :void
    {
        addLoadable(Flashbang.rsrcs.createResource(type, name, loadParams));
    }

    override protected function succeed (result :* = undefined) :void
    {
        Flashbang.rsrcs.addResources(this);
        super.succeed(result);
    }

    override protected function doUnload () :void
    {
        super.doUnload();
        Flashbang.rsrcs.removeResources(this);
    }

    internal function get resources () :Array
    {
        return _loadedObjects.filter(function (l :Loadable, ..._) :Boolean {
            return l is Resource;
        });
    }

    protected static const log :Log = Log.getLog(ResourceSet);
}

}
