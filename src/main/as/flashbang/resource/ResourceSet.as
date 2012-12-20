//
// Flashbang

package flashbang.resource {

import flashbang.Flashbang;
import flashbang.util.Loadable;
import flashbang.util.LoadableBatch;

public class ResourceSet extends LoadableBatch
{
    public function ResourceSet (maxSimultaneous :int = 0)
    {
        super(maxSimultaneous);
    }

    public function add (loadParams :Object) :void
    {
        addLoadable(Flashbang.rsrcs.createLoader(loadParams));
    }

    public function unload () :void
    {
        Flashbang.rsrcs.unloadSet(this);
    }

    override protected function succeed (result :* = undefined) :void
    {
        // get all our resources
        var loaded :Array = result as Array;
        var resources :Array = [];
        for each (var l :Loadable in loaded) {
            if (l is ResourceLoader) {
                var thisResult :* = l.result;
                if (thisResult is Resource) {
                    resources.push(thisResult);
                } else if (thisResult is Array) {
                    resources = resources.concat(thisResult);
                } else {
                    fail(Error("ResourceLoader.result must be a Resource or Array of Resources"));
                }
            }
        }

        Flashbang.rsrcs.addSet(this, resources);

        // Don't pass result through to LoadableBatch. We don't want extra references
        // to the resources
        super.succeed();
    }
}

}
