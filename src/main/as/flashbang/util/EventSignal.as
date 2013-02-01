//
// flashbang

package flashbang.util {

import starling.events.Event;
import starling.events.EventDispatcher;

import org.osflash.signals.ISignal;
import org.osflash.signals.ISlot;
import org.osflash.signals.Signal;

/** Redispatches an Event as a Signal */
public class EventSignal
    implements ISignal
{
    public function EventSignal (dispatcher :EventDispatcher, eventType :String) {
        _dispatcher = dispatcher;
        _eventType = eventType;
    }

    public function add (listener :Function) :ISlot {
        connect();
        return _signal.add(listener);
    }

    public function addOnce (listener :Function) :ISlot {
        connect();
        return _signal.addOnce(listener);
    }

    public function get valueClasses () :Array {
        return _signal.valueClasses;
    }

    public function set valueClasses (value :Array) :void {
        _signal.valueClasses = value;
    }

    public function get numListeners () :uint {
        return _signal.numListeners;
    }

    public function dispatch (...valueObjects) :void {
        _signal.dispatch.apply(_signal, valueObjects);
    }

    public function remove (listener :Function) :ISlot {
        var toReturn :ISlot = _signal.remove(listener);
        if (_signal.numListeners == 0) {
            disconnect();
        }
        return toReturn;
    }

    public function removeAll () :void {
        _signal.removeAll();
        disconnect();
    }

    protected function connect () :void {
        if (!_connected) {
            _connected = true;
            _dispatcher.addEventListener(_eventType, listener);
        }
    }

    protected function disconnect () :void {
        if (_connected) {
            _connected = false;
            _dispatcher.removeEventListener(_eventType, listener);
        }
    }

    protected function listener (e :Event) :void {
        _signal.dispatch(e);
    }

    protected const _signal :Signal = new Signal(Event);

    protected var _dispatcher :EventDispatcher;
    protected var _eventType :String;
    protected var _connected :Boolean;
}
}
