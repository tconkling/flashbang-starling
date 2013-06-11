//
// flashbang

package flashbang.util {

import react.AbstractSignal;

import starling.events.Event;
import starling.events.EventDispatcher;

/** Redispatches a Starling Event as a Signal */
public class EventSignal extends AbstractSignal
{
    public function EventSignal (dispatcher :EventDispatcher, eventType :String) {
        _dispatcher = dispatcher;
        _eventType = eventType;
    }

    public function emit (e :Event) :void {
        notifyEmit(e);
    }

    override protected function connectionAdded () :void {
        super.connectionAdded();
        if (!_connected) {
            connectToSource();
        }
    }

    override protected function connectionRemoved () :void {
        super.connectionRemoved();
        if (!this.hasConnections && _connected) {
            disconnectFromSource();
        }
    }

    protected function connectToSource () :void {
        if (!_connected) {
            _connected = true;
            _dispatcher.addEventListener(_eventType, emit);
        }
    }

    protected function disconnectFromSource () :void {
        if (_connected) {
            _connected = false;
            _dispatcher.removeEventListener(_eventType, emit);
        }
    }


    protected var _dispatcher :EventDispatcher;
    protected var _eventType :String;
    protected var _connected :Boolean;
}
}
