//
// Flashbang

package flashbang.resource {

import flashbang.core.Flashbang;
import flashbang.loader.BatchLoader;
import flashbang.loader.DataLoader;

public class ResourceSet extends BatchLoader
{
    public function ResourceSet (maxSimultaneous :int = 0) {
        super(maxSimultaneous);
    }

    public function add (loadParams :Object) :void {
        addLoader(Flashbang.rsrcs.createLoader(loadParams));
    }

    public function addAll (loadParamsArray :Array) :void {
        for each (var params :Object in loadParamsArray) {
            add(params);
        }
    }

    public function unload () :void {
        Flashbang.rsrcs.unloadSet(this);
    }

    override public function succeed (value :Object = null) :void {
        // get all our resources
        var loaded :Vector.<DataLoader> = Vector.<DataLoader>(value);
        var resources :Vector.<Resource> = new <Resource>[];
        for each (var l :DataLoader in loaded) {
            if (l is ResourceLoader) {
                var thisResult :* = l.result;
                if (thisResult is Resource) {
                    resources.push(Resource(thisResult));
                } else if (thisResult is Vector.<Resource>) {
                    resources = resources.concat(Vector.<Resource>(thisResult));
                } else {
                    fail("ResourceLoader.result must be a Resource or Vector of Resources");
                    return;
                }
            }
        }

        Flashbang.rsrcs.addSet(this, resources);

        // Don't pass result through to BatchLoader. We don't want extra references
        // to the resources
        super.succeed();
    }
}

}
