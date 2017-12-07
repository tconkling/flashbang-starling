//
// Flashbang

package flashbang.resource {

import aspire.util.Preconditions;

import flashbang.core.Flashbang;
import flashbang.util.BatchProgress;
import flashbang.util.Process;

import react.Executor;
import react.Future;
import react.NumberView;

public class ResourceSet implements Process {
    public function get progress () :NumberView {
        return _batchProcess.progress;
    }

    public function get totalSize () :Number {
        return _batchProcess.totalSize;
    }

    /**
     * Our result is a Future<Void> - we add our resources to the ResourceManager directly on
     * success, and they are not accessible externally. This will be null before load() is called.
     */
    public function get result () :Future {
        return _result;
    }

    public function executor (exec :Executor) :ResourceSet {
        Preconditions.checkState(!this.hasLoaded, "Already loaded");
        _exec = exec;
        return this;
    }

    public function add (loadParams :Object) :ResourceSet {
        Preconditions.checkState(!this.hasLoaded, "Already loaded");
        var loader :IResourceLoader = Flashbang.rsrcs.createLoader(loadParams);
        _loaders[_loaders.length] = loader;
        _batchProcess.add(loader, loader.loadSize);
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
        if (_loaders == null) {
            return _result;
        }

        if (_exec == null) {
            _exec = new Executor();
        }

        var futures :Array = _loaders.map(function (loader :IResourceLoader, ..._) :Future {
            return _exec.submit(loader.begin);
        });

        // Null out our loaders Array to indicate we've already loaded
        _loaders = null;

        _result = Future.sequence(futures).flatMap(onResourcesLoaded);

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

    protected function get hasLoaded () :Boolean {
        // We null out our loaders as soon as we begin loading
        return _loaders == null;
    }

    private var _exec :Executor;
    private var _batchProcess :BatchProgress = new BatchProgress();
    private var _loaders :Array = [];
    private var _result :Future;
}

}
