//
// flashbang

package flashbang.input {

import react.SignalView;

import starling.display.DisplayObject;

/** Exposes touch signals for an object that can be touched */
public interface Touchable
{
    /** Returns the DisplayObject associated with this Touchable */
    function get target () :DisplayObject;

    /**
     * Fired when a TouchEvent is dispatched on the object.
     * If you're only interested in a single touch phase, you can use one of the phase-specific
     * signals instead.
     */
    function get touchEvent () :SignalView; // Signal<TouchEvent>

    /** Fired when a Touch in the HOVER phase is dispatched on the object */
    function get hoverBegan () :SignalView; // Signal<Touch>

    /** Fired when a hovered object loses its hovered status */
    function get hoverEnded () :SignalView; // UnitSignal<>

    /** Fired when a Touch in the BEGAN phase is dispatched on the object */
    function get touchBegan () :SignalView; // Signal<Touch>

    /** Fired when a Touch in the MOVED phase is dispatched on the object */
    function get touchMoved () :SignalView; // Signal<Touch>

    /** Fired when a Touch in the STATIONARY phase is dispatched on the object */
    function get touchStationary () :SignalView; // Signal<Touch>

    /** Fired when a Touch in the ENDED phase is dispatched on the object */
    function get touchEnded () :SignalView; // Signal<Touch>
}
}
