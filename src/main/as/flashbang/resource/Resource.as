//
// Flashbang

package flashbang.resource {

import aspire.util.ClassUtil;
import aspire.util.Joiner;
import aspire.util.StringUtil;

import flashbang.util.Loadable;

public class Resource extends Loadable
{
    public function Resource (name :String, params :Object)
    {
        _name = name;
        _params = params;
    }

    public function get name () :String
    {
        return _name;
    }

    protected function hasLoadParam (name :String) :Boolean
    {
        return _params.hasOwnProperty(name);
    }

    protected function getLoadParam (name :String, defaultValue :* = undefined) :*
    {
        return (hasLoadParam(name) ? _params[name] : defaultValue);
    }

    protected function requireLoadParam (name :String, type :Class) :*
    {
        if (!hasLoadParam(name)) {
            throw new Error("Missing required loadParam [name=" + name + "]");
        }
        var param :* = getLoadParam(name);
        if (!(param is type)) {
            throw new Error("Bad load param [name=" + name + " type=" + type + "]");
        }
        return param;
    }

    override protected function fail (e :Error) :void
    {
        super.fail(new Error(Joiner.pairs(ClassUtil.tinyClassName(this) + " load error",
            "name", _name, "params", StringUtil.simpleToString(_params),
            "err", e.message)));
    }

    protected var _name :String;
    protected var _params :Object;
}

}
