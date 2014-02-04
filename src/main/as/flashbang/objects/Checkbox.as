//
// flashbang

package flashbang.objects {

import react.BoolValue;
import react.ValueView;

import starling.display.Sprite;

/**
 * A Checkbox base class. Abstract.
 */
public class Checkbox extends Button
{
    public function Checkbox (sprite :Sprite = null) {
        super(sprite);

        clicked.connect(onClicked);
        _value.connect(onValueChanged);
    }

    public function get valueView () :ValueView {
        return _value;
    }

    public function get value () :Boolean {
        return _value.value;
    }

    public function set value (newVal :Boolean) :void {
        _value.value = newVal;
    }

    /** Subclasses must override this to display the appropriate state */
    protected function showCheckboxState (buttonState :int, val :Boolean) :void {
        throw new Error("abstract");
    }

    protected function onValueChanged (newVal :Boolean) :void {
        showCheckboxState(_state, newVal);
    }

    protected function onClicked () :void {
        // toggle our value
        this._value.value = !this._value.value;
    }

    override protected final function showState (state :int) :void {
        showCheckboxState(state, this._value.value);
    }

    protected const _value :BoolValue = new BoolValue();
}
}
