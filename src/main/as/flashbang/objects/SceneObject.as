//
// Flashbang

package flashbang.objects {

import flashbang.components.DisplayComponent;
import flashbang.core.GameObject;
import flashbang.input.Input;
import flashbang.input.Touchable;

import react.SignalView;

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

    public function get target () :DisplayObject {
        return _displayObject;
    }

    public function get touchEvent () :SignalView { // Signal<TouchEvent>
        return getTouchable().touchEvent;
    }

    public function get hoverBegan () :SignalView { // Signal<Touch>
        return getTouchable().hoverBegan;
    }

    public function get hoverEnded () :SignalView { // UnitSignal<>
        return getTouchable().hoverEnded;
    }

    public function get touchBegan () :SignalView { // Signal<Touch>
        return getTouchable().touchBegan;
    }

    public function get touchMoved () :SignalView { // Signal<Touch>
        return getTouchable().touchMoved;
    }

    public function get touchStationary () :SignalView { // Signal<Touch>
        return getTouchable().touchStationary;
    }

    public function get touchEnded () :SignalView { // Signal<Touch>
        return getTouchable().touchEnded;
    }

    override public function get ids () :Array {
        return (_id != null ? [ _id ].concat(super.ids) : super.ids);
    }

    override public function get groups () :Array {
        return (_group != null ? [ _group ].concat(super.groups) : super.groups);
    }

    override protected function dispose () :void {
        super.dispose();
        if (_displayObject != null) {
            _displayObject.dispose();
            _displayObject = null;
        }
    }

    protected function getTouchable () :Touchable {
        if (_touchable == null) {
            _touchable = Input.newTouchable(_displayObject);
        }
        return _touchable;
    }

    protected var _displayObject :DisplayObject;
    protected var _touchable :Touchable; // lazily instantiated

    protected var _id :Object;
    protected var _group :Object;
}

}
