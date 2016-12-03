//
// flashbang

package flashbang.objects {

import react.BoolValue;
import react.ValueView;

import starling.display.Sprite;

/** A two-state Button whose value is toggled on click (e.g. a checkbox). */
public /*abstract*/ class ToggleButton extends Button
{
    public function ToggleButton (sprite :Sprite = null) {
        super(sprite);
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
    protected function showToggleState (buttonState :String, value :Boolean) :void {
        throw new Error("abstract");
    }

    protected function onValueChanged (newValue :Boolean) :void {
        showToggleState(_state, newValue);
    }

    override protected final function showState (state :String) :void {
        showToggleState(state, this._value.value);
    }

    protected const _value :BoolValue = new BoolValue();
}
}
