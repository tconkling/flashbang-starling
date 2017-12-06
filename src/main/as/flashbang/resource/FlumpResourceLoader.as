//
// flashbang

package flashbang.resource {

import aspire.util.ClassUtil;

import flash.utils.ByteArray;

import flashbang.loader.FlumpLoader;

import flump.display.Library;

import react.Executor;
import react.Future;
import react.NumberView;

public class FlumpResourceLoader implements ResourceLoader {
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

    public function FlumpResourceLoader (params :Object) {
        _name = Params.require(params, NAME, String);
        _loadSize = Params.get(params, LOAD_SIZE, 1);
        var mipmaps :Boolean = Params.get(params, MIPMAPS, false) as Boolean;
        var data :Object = Params.require(params, DATA, Object);

        if (data is Class) {
            var clazz :Class = Class(data);
            data = ByteArray(new clazz());
        }

        _flumpLoader = new FlumpLoader(data).generateMipmaps(mipmaps);
        _result = _flumpLoader.result.map(function (library :Library) :Vector.<Resource> {
            return FlumpLibraryResource.createResources(_name, library);
        });
    }

    public function get processSize () :Number {
        return _loadSize;
    }

    public function get progress () :NumberView {
        return _flumpLoader.progress;
    }

    public function executor (exec :Executor) :void {
        _exec = exec;
    }

    public function get result () :Future {
        return _result;
    }

    public function begin () :Future {
        if (!_began) {
            _began = true;
            if (_exec != null) {
                _exec.submit(_flumpLoader.begin);
            } else {
                _flumpLoader.begin();
            }
        }
        return _result;
    }

    public function toString () :String {
        return _name + " (" + ClassUtil.tinyClassName(this) + ")";
    }

    protected var _name :String;
    protected var _loadSize :Number;

    protected var _exec :Executor;
    protected var _flumpLoader :FlumpLoader;
    protected var _result :Future;
    protected var _began :Boolean;
}
}
