//
// Flashbang

package flashbang.objects {

import flashbang.components.DisplayComponent;
import flashbang.core.GameObject;
import flashbang.input.TouchSignals;
import flashbang.input.Touchable;

import org.osflash.signals.ISignal;

import starling.display.DisplayObject;

/**
 * A convenience class that implements DisplayComponent and manages a displayObject directly.
 */
public class SceneObject extends GameObject
    implements DisplayComponent, Touchable
{
    public function SceneObject (displayObject :DisplayObject, id :Object = null,
        group :Object = null) {
        _displayObject = displayObject;
    }

    public final function get display () :DisplayObject {
        return _displayObject;
    }

    public function get touchEvent () :ISignal { // Signal<TouchEvent>
        return getTouchable().touchEvent;
    }

    public function get touchHover () :ISignal { // Signal<Touch>
        return getTouchable().touchHover;
    }

    public function get touchBegan () :ISignal { // Signal<Touch>
        return getTouchable().touchBegan;
    }

    public function get touchMoved () :ISignal { // Signal<Touch>
        return getTouchable().touchMoved;
    }

    public function get touchStationary () :ISignal { // Signal<Touch>
        return getTouchable().touchStationary;
    }

    public function get touchEnded () :ISignal { // Signal<Touch>
        return getTouchable().touchEnded;
    }

    override public function get objectIds () :Array {
        return (_id != null ? [ _id ] : []);
    }

    override public function get objectGroups () :Array {
        return (_group != null ? [ _group ] : []);
    }

    override protected function cleanup () :void {
        super.cleanup();
        if (_displayObject != null) {
            _displayObject.dispose();
            _displayObject = null;
        }
    }

    protected function getTouchable () :Touchable {
        if (_touchable == null) {
            _touchable = TouchSignals.forDisp(_displayObject);
        }
        return _touchable;
    }

    protected var _displayObject :DisplayObject;
    protected var _touchable :Touchable; // lazily instantiated

    protected var _id :Object;
    protected var _group :Object;
}

}
