//
// flashbang

package flashbang.resource {

import aspire.util.ClassUtil;
import aspire.util.Joiner;
import aspire.util.StringUtil;

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

    override protected function fail (e :Error) :void {
        super.fail(new Error(Joiner.pairs(ClassUtil.tinyClassName(this) + " load error",
            "params", StringUtil.simpleToString(_params), "err", e.message)));
    }

    protected var _params :Object;
}
}
