//
// flashbang

package flashbang.input {

public interface MouseWheelListener
{
    /**
     * Return true to indicate that the event has been fully handled and processing
     * should stop.
     */
    function onMouseWheelEvent (e :MouseWheelEvent) :Boolean;
}
}
