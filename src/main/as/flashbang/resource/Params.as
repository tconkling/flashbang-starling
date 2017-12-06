//
// aciv

package flashbang.resource {

public class Params {
    public static function exists (params :Object, name :String) :Boolean {
        return params.hasOwnProperty(name);
    }

    public static function get (params :Object, name :String, defaultValue :* = undefined) :* {
        return (exists(params, name) ? params[name] : defaultValue);
    }

    public static function require (params :Object, name :String, type :Class = null) :* {
        if (!exists(params, name)) {
            throw new Error("Missing required param [name=" + name + "]");
        }
        var param :* = get(params, name);
        if (type != null && !(param is type)) {
            throw new Error("Bad param [name=" + name + " type=" + type + "]");
        }
        return param;
    }
}
}
