//
// aciv

package flashbang.resource {

import react.Future;
import react.NumberValue;
import react.NumberView;

public class AbstractResourceLoader implements IResourceLoader {
    /** The loadSize of the resource (optional, defaults to 1) */
    public static const LOAD_SIZE :String = "loadSize";

    public function AbstractResourceLoader (params :Object) {
        _params = params;
    }

    public function get loadSize () :Number {
        return getLoadParam(LOAD_SIZE, 1);
    }

    public function get progress () :NumberView {
        return _progress;
    }

    public function get result () :Future {
        throw new Error("abstract");
    }

    public function load () :Future {
        throw new Error("abstract");
    }

    protected function hasLoadParam (name :String) :Boolean {
        return _params.hasOwnProperty(name);
    }

    protected function getLoadParam (name :String, defaultValue :* = undefined) :* {
        return (hasLoadParam(name) ? _params[name] : defaultValue);
    }

    protected function requireLoadParam (name :String, type :Class = null) :* {
        if (!hasLoadParam(name)) {
            throw new Error("Missing required loadParam [name=" + name + "]");
        }
        var param :* = getLoadParam(name);
        if (type != null && !(param is type)) {
            throw new Error("Bad load param [name=" + name + " type=" + type + "]");
        }
        return param;
    }

    protected var _params :Object;
    protected var _progress :NumberValue = new NumberValue();
}
}
