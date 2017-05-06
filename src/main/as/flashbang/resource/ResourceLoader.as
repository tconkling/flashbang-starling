//
// flashbang

package flashbang.resource {

import aspire.util.ClassUtil;

import flash.events.ErrorEvent;

import flashbang.loader.DataLoader;
import flashbang.util.Process;

import react.NumberValue;
import react.NumberView;

public class ResourceLoader extends DataLoader implements Process
{
    /** The loadSize of the resource (optional, defaults to 1) */
    public static const LOAD_SIZE :String = "loadSize";

    public function ResourceLoader (params :Object) {
        _params = params;
    }

    /**
     * The "size" of the resource being loaded. This is a relative value that indicates
     * how long the resource will take to load in relation to other resources.
     * It does not necessarily correspond to any sort of byte size on disk.
     */
    public final function get processSize () :Number {
        return getLoadParam(LOAD_SIZE, 1);
    }

    /**
     * Subclasses can optionally expose a loadProgress that they update incrementally while
     * their resource is loading. LoadProgress values are Numbers between 0 and 1.
     */
    public final function get progress () :NumberView {
        return _loadProgress;
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

    override public function succeed (value :Object = null) :void {
        if (!this.wasCanceled) {
            _loadProgress.value = 1;
        }
        super.succeed(value);
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
    protected var _loadProgress :NumberValue = new NumberValue(0);
}
}
