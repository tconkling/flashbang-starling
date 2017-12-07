//
// flashbang

package flashbang.resource {

import aspire.util.ClassUtil;

import flash.events.ProgressEvent;
import flash.utils.ByteArray;

import flump.display.Library;
import flump.display.LibraryLoader;
import flump.executor.Future;

import react.Future;
import react.NumberValue;
import react.NumberView;
import react.Promise;

public class FlumpLibraryLoader implements IResourceLoader {
    /** The name of the Library (required) */
    public static const NAME :String = "name";

    /**
     * a String containing a URL to load the Library from OR
     * a ByteArray containing the Library OR
     * an [Embed]ed class containing the Library data
     * (required)
     */
    public static const DATA :String = "data";

    /**
     * A Boolean indicating if mipmaps should be generated for the flump textures loaded with
     * this loader. The default is false.
     */
    public static const MIPMAPS :String = "mipmaps";

    /** The loadSize of the resource (optional, defaults to 1) */
    public static const LOAD_SIZE :String = "loadSize";

    public function FlumpLibraryLoader (params :Object) {
        _params = params;
    }

    public function get loadSize () :Number {
        return Params.get(_params, LOAD_SIZE, 1);
    }

    public function get progress () :NumberView {
        return _progress;
    }

    public function get result () :react.Future {
        return _result;
    }

    public function load () :Future {
        try {
            _name = Params.require(_params, NAME, String);
            var data :Object = Params.require(_params, DATA, Object);
            if (data is Class) {
                var clazz :Class = Class(data);
                data = ByteArray(new clazz());
            }
            _mipmaps = Params.get(_params, MIPMAPS, false) as Boolean;

            var loader :LibraryLoader = createLibraryLoader();

            var flumpFuture :flump.executor.Future;
            if (data is ByteArray) {
                flumpFuture = loader.loadBytes(ByteArray(data));

            } else if (data is String) {
                flumpFuture = loader.loadURL(data as String);

            } else {
                _result.fail("Unrecognized Flump Library data source: '" + ClassUtil.tinyClassName(data) + "'");
                return _result;
            }

            loader.urlLoadProgressed.connect(onLoadProgress);

            flumpFuture.succeeded.connect(libraryLoaded);
            flumpFuture.failed.connect(_result.fail);

        } catch (e :Error) {
            _result.fail(e);
        }
    }

    protected function onLoadProgress (e :ProgressEvent) :void {
        _progress.value = (e.bytesLoaded / e.bytesTotal);
    }

    protected function createLibraryLoader () :LibraryLoader {
        return new LibraryLoader().setGenerateMipMaps(_mipmaps);
    }

    protected function libraryLoaded (library :Library) :void {
        var resources :Vector.<Resource> = new <Resource>[];

        // create a (private) resource for the library itself
        resources.push(new LibraryResource(_name, library));

        // create individual resources for each symbol in the library
        for each (var movieName :String in library.movieSymbols) {
            resources.push(new MovieResource(library, _name, movieName));
        }
        for each (var imageName :String in library.imageSymbols) {
            resources.push(new ImageResource(library, _name, imageName));
        }

        _result.succeed(resources);
    }

    public function toString () :String {
        return Params.get(_params, NAME) + " (" + ClassUtil.tinyClassName(this) + ")";
    }

    protected var _params :Object;
    protected var _name :String;
    protected var _mipmaps :Boolean;
    protected var _progress :NumberValue = new NumberValue();
    protected var _result :Promise = new Promise();
}
}

import flashbang.resource.Resource;

import flump.display.Library;

class LibraryResource extends Resource {
    public function LibraryResource (name :String, lib :Library) {
        super(name);
        _lib = lib;
    }

    override protected function dispose () :void {
        _lib.dispose();
        _lib = null;
    }

    private var _lib :Library;
}
