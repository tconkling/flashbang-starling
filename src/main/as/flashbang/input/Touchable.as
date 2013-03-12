//
// flashbang

package flashbang.input {

import org.osflash.signals.ISignal;

/** Exposes touch signals for an object that can be touched */
public interface Touchable
{
    /**
     * Fired when a TouchEvent is dispatched on the object.
     * If you're only interested in a single touch phase, you can use one of the phase-specific
     * signals instead.
     */
    function get touchEvent () :ISignal; // Signal<TouchEvent>

    /** Fired when a Touch in the HOVER phase is dispatched on the object */
    function get touchHover () :ISignal; // Signal<Touch>

    /** Fired when a Touch in the BEGAN phase is dispatched on the object */
    function get touchBegan () :ISignal; // Signal<Touch>

    /** Fired when a Touch in the MOVED phase is dispatched on the object */
    function get touchMoved () :ISignal; // Signal<Touch>

    /** Fired when a Touch in the STATIONARY phase is dispatched on the object */
    function get touchStationary () :ISignal; // Signal<Touch>

    /** Fired when a Touch in the ENDED phase is dispatched on the object */
    function get touchEnded () :ISignal; // Signal<Touch>
}
}
