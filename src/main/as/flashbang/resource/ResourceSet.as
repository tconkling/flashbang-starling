//
// Flashbang

package flashbang.resource {

import flashbang.core.Flashbang;
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
        var loaded :Vector.<Loadable> = result;
        var resources :Vector.<Resource> = new <Resource>[];
        for each (var l :Loadable in loaded) {
            if (l is ResourceLoader) {
                var thisResult :* = l.result;
                if (thisResult is Resource) {
                    resources.push(Resource(thisResult));
                } else if (thisResult is Vector.<Resource>) {
                    resources = resources.concat(Vector.<Resource>(thisResult));
                } else {
                    fail(Error("ResourceLoader.result must be a Resource or Vector of Resources"));
                    return;
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
