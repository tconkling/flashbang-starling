//
// flashbang

package flashbang.resource {

import aspire.util.ClassUtil;

import flash.events.ErrorEvent;

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

    override public function fail (cause :Object) :void {
        // add some context
        var msg :String = ClassUtil.tinyClassName(this) + " load error\n";
        for (var key :String in _params) {
            msg += "\t" + key + ": " + _params[key] + "\n";
        }

        if (cause is Error) {
            Error(cause).message = msg + Error(cause).message;
        } else if (cause is ErrorEvent) {
            var ee :ErrorEvent = cause as ErrorEvent;
            cause = new Error(msg + "An ErrorEvent occurred [type=" +
                ClassUtil.tinyClassName(cause) + ", message=" + ee.text + "]");
        } else if (cause is String) {
            cause = msg + (cause as String);
        } else {
            cause = new Error(msg + "An unknown failure occurred" +
                (cause != null ? " (" + cause + ")" : ""));
        }
        super.fail(cause);
    }

    protected var _params :Object;
}
}
