//
// flashbang

package flashbang.util {

import flashbang.components.Disableable;

/** Handles mass disabling of objects, e.g. while waiting for a network response */
public class Disabler
    implements Disableable
{
    public function add (obj :Disableable) :void {
        var os :ObjectState = new ObjectState(obj);
        _objects.push(os);

        if (!_enabled) {
            os.saveStateAndDisable();
        }
    }

    public function get enabled () :Boolean {
        return _enabled;
    }

    public function set enabled (val :Boolean) :void {
        if (_enabled == val) {
            return;
        }

        _enabled = val;

        for each (var obj :ObjectState in _objects) {
            if (!obj.isLive) {
                continue;
            }

            if (!_enabled) {
                obj.saveStateAndDisable();
            } else {
                obj.restoreState();
            }
        }
    }

    protected var _enabled :Boolean = true;

    protected var _objects :Vector.<ObjectState> = new <ObjectState>[];
}
}

import flashbang.components.Disableable;
import flashbang.core.GameObject;

class ObjectState {
    public function ObjectState (obj :Disableable) {
        _obj = obj;
    }

    public function get  isLive () :Boolean {
        return !(_obj is GameObject) || GameObject(_obj).isLiveObject;
    }

    public function saveStateAndDisable () :void {
        _wasEnabled = _obj.enabled;
        _obj.enabled = false;
    }

    public function restoreState () :void {
        _obj.enabled = _wasEnabled;
    }

    private var _obj :Disableable;
    private var _wasEnabled :Boolean;
}
