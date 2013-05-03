//
// flashbang

package flashbang.resource {

import aspire.util.ClassUtil;

import flashbang.loader.DataLoader;

public class ResourceLoader extends DataLoader
{
    public function ResourceLoader (params :Object) {
        _params = params;
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

    override protected function fail (result :* = undefined) :void {
        var e :Error = resultToError(result);
        // add some context
        var msg :String = ClassUtil.tinyClassName(this) + " load error\n";
        for (var key :String in _params) {
            msg += "\t" + key + ": " + _params[key] + "\n";
        }
        e.message = msg + e.message;
        super.fail(e);
    }

    protected var _params :Object;
}
}
