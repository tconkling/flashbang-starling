//
// Flashbang

package flashbang.resource {

import aspire.util.Preconditions;

import flashbang.core.Flashbang;
import flashbang.util.BatchProcess;
import flashbang.util.HasProcessSize;
import flashbang.util.Process;

import react.Executor;
import react.Future;
import react.NumberView;

public class ResourceSet implements Process, HasProcessSize {
    public function get isLoaded () :Boolean {
        return _result != null && _result.isComplete.value;
    }

    public function get progress () :NumberView {
        return _batch.progress;
    }

    public function get processSize () :Number {
        return _batch.processSize;
    }

    /**
     * Our result is a Future<Void> - we add our resources to the ResourceManager directly on
     * success, and they are not accessible externally. This will be null before load() is called.
     */
    public function get result () :Future {
        return _result;
    }

    public function executor (exec :Executor) :ResourceSet {
        Preconditions.checkState(!this.began, "Already loaded");
        _batch.executor(exec);
        return this;
    }

    public function add (loadParams :Object) :ResourceSet {
        Preconditions.checkState(!this.began, "Already loaded");
        var loader :ResourceLoader = Flashbang.rsrcs.createLoader(loadParams);
        _batch.add(loader);
        return this;
    }

    public function addAll (loadParamsArray :Array) :ResourceSet {
        for each (var params :Object in loadParamsArray) {
            add(params);
        }
        return this;
    }

    /** An alias for begin() */
    public function load () :Future {
        return begin();
    }

    public function begin () :Future {
        if (!this.began) {
            _result = _batch.begin().flatMap(onResourcesLoaded);
        }
        return _result;
    }

    public function unload () :void {
        Flashbang.rsrcs.unloadSet(this);
    }

    protected function onResourcesLoaded (results :Array) :Future {
        // get all our resources
        var resources :Vector.<Resource> = new <Resource>[];
        for each (var result :* in results) {
            if (result is Resource) {
                resources[resources.length] = result;
            } else if (result is Vector.<Resource>) {
                resources = resources.concat(Vector.<Resource>(result));
            } else {
                return Future.failure("ResourceLoader.result must be a Resource or Vector of Resources");
            }
        }

        try {
            Flashbang.rsrcs.addSet(this, resources);
        } catch (err :Error) {
            return Future.failure(err);
        }

        return Future.success();
    }

    protected function get began () :Boolean {
        return _result != null;
    }

    private var _batch :BatchProcess = new BatchProcess();
    private var _result :Future;
}

}
