//
// Flashbang

package flashbang.resource {

import aspire.util.Log;

import flashbang.core.Flashbang;
import flashbang.loader.BatchLoader;
import flashbang.loader.DataLoader;
import flashbang.util.BatchProcess;
import flashbang.util.Process;

import react.NumberView;

public class ResourceSet extends BatchLoader implements Process
{
    public function ResourceSet (maxSimultaneous :int = 0) {
        super(maxSimultaneous);
    }

    public function get totalSize () :Number {
        return _batchProcess.totalSize;
    }

    public function get progress () :NumberView {
        return _batchProcess.progress;
    }

    public function add (loadParams :Object) :void {
        var loader :ResourceLoader = Flashbang.rsrcs.createLoader(loadParams);
        addLoader(loader);
        _batchProcess.add(loader);
    }

    public function addAll (loadParamsArray :Array) :void {
        for each (var params :Object in loadParamsArray) {
            add(params);
        }
    }

    public function unload () :void {
        Flashbang.rsrcs.unloadSet(this);
    }

    override protected function loaderBegan (loader :DataLoader) :void {
        log.debug("Loading '" + loader + "'...");
    }

    override protected function loaderCompleted (loader :DataLoader) :void {
        log.debug("Completed '" + loader + "'");
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

    private var _batchProcess :BatchProcess = new BatchProcess();

    private static const log :Log = Log.getLog(ResourceSet);
}

}
