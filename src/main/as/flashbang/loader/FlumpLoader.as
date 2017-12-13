//
// aciv

package flashbang.loader {

import flash.events.ProgressEvent;
import flash.utils.ByteArray;

import flashbang.util.Process;

import flump.display.CreatorFactory;

import flump.display.LibraryLoader;
import flump.executor.Future;

import react.Future;
import react.NumberValue;
import react.NumberView;
import react.Promise;

/** Loads a flump.display.Library */
public class FlumpLoader implements Process {
    public function FlumpLoader (urlOrBytes :*) {
        if (urlOrBytes is String) {
            _url = urlOrBytes;
        } else if (urlOrBytes is ByteArray) {
            _bytes = urlOrBytes;
        } else {
            throw new Error("urlOrBytes must be a String or ByteArray");
        }
    }

    /** @return Future<Library>. It's ok to access `result` before `begin()` is called. */
    public function get result () :react.Future {
        return _result;
    }

    public function get progress () :NumberView {
        return _progress;
    }

    public function generateMipmaps (val :Boolean = true) :FlumpLoader {
        _generateMipmaps = val;
        return this;
    }

    /** Sets the CreatorFactory that Flump will use during library creation. */
    public function creatorFactory (val :CreatorFactory) :FlumpLoader {
        _creatorFactory = val;
        return this;
    }

    public function begin () :react.Future {
        if (_began) {
            return _result;
        }
        _began = true;

        var loader :LibraryLoader = new LibraryLoader().setGenerateMipMaps(_generateMipmaps);
        if (_creatorFactory != null) {
            loader.setCreatorFactory(_creatorFactory);
        }

        var flumpFuture :flump.executor.Future = (_url != null ?
            loader.loadURL(_url) :
            loader.loadBytes(_bytes));

        loader.urlLoadProgressed.connect(onLoadProgress);

        flumpFuture.succeeded.connect(_result.succeed);
        flumpFuture.failed.connect(_result.fail);

        return _result;
    }

    protected function onLoadProgress (e :ProgressEvent) :void {
        _progress.value = (e.bytesLoaded / e.bytesTotal);
    }

    protected const _result :Promise = new Promise();
    protected const _progress :NumberValue = new NumberValue();

    protected var _began :Boolean;
    protected var _url :String;
    protected var _bytes :ByteArray;
    protected var _generateMipmaps :Boolean;
    protected var _creatorFactory :CreatorFactory;
}
}
