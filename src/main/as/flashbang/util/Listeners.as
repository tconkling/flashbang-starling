//
// Flashbang

package flashbang.util {

import aspire.util.RegistrationList;

import flash.events.IEventDispatcher;

import org.osflash.signals.ISignal;

import starling.events.EventDispatcher;

/** Assists with the management of Signal and Event listeners */
public class Listeners extends RegistrationList
{
    /**
     * Adds a listener to the specified signal.
     * @return an EventRegistration object that will disconnect the listener from the signal.
     */
    public function addSignalListener (signal :ISignal, l :Function) :EventRegistration {
        return add(new SignalRegistration(signal, l)) as EventRegistration;
    }

    /**
     * Adds a listener to the specified EventDispatcher for the specified event type.
     * Note: this works with both Starling and Flash EventDispatchers.
     * @return a Registration object that will disconnect the listener from the EventDispatcher.
     */
    public function addEventListener (dispatcher :Object, type :String, l :Function) :EventRegistration {
        if (dispatcher is IEventDispatcher) {
            return add(new FlashEventRegistration(IEventDispatcher(dispatcher), type, l)) as EventRegistration;
        } else {
            return add(new StarlingEventRegistration(EventDispatcher(dispatcher), type, l)) as EventRegistration;
        }
    }
}
}

import flash.events.Event;
import flash.events.IEventDispatcher;

import flashbang.util.EventRegistration;

import org.osflash.signals.ISignal;
import org.osflash.signals.ISlot;

import starling.events.Event;
import starling.events.EventDispatcher;

class StarlingEventRegistration
    implements EventRegistration
{
    public function StarlingEventRegistration (dispatcher :EventDispatcher, type :String,
        f :Function) {
        _dispatcher = dispatcher;
        _type = type;
        _f = f;
        _dispatcher.addEventListener(type, onEvent);
    }

    public function cancel () :void {
        if (_dispatcher != null) {
            _dispatcher.removeEventListener(_type, onEvent);
            _dispatcher = null;
            _f = null;
        }
    }

    public function once () :EventRegistration {
        _once = true;
        return this;
    }

    protected function onEvent (e :starling.events.Event) :void {
        var f :Function = _f;
        if (_once) {
            cancel();
        }
        f(e);
    }

    protected var _dispatcher :EventDispatcher;
    protected var _type :String;
    protected var _f :Function;
    protected var _once :Boolean;
}

class FlashEventRegistration
    implements EventRegistration
{
    public function FlashEventRegistration (dispatcher :IEventDispatcher, type :String,
        f :Function) {
        _dispatcher = dispatcher;
        _type = type;
        _f = f;
        _dispatcher.addEventListener(type, onEvent);
    }

    public function cancel () :void {
        if (_dispatcher != null) {
            _dispatcher.removeEventListener(_type, onEvent);
            _dispatcher = null;
            _f = null;
        }
    }

    public function once () :EventRegistration {
        _once = true;
        return this;
    }

    protected function onEvent (e :flash.events.Event) :void {
        var f :Function = _f;
        if (_once) {
            cancel();
        }
        f(e);
    }

    protected var _dispatcher :IEventDispatcher;
    protected var _type :String;
    protected var _f :Function;
    protected var _once :Boolean;
}

class SignalRegistration
    implements EventRegistration
{
    public function SignalRegistration (signal :ISignal, f :Function) {
        _slot = signal.add(onSignalDispatch);
        _f = f;
    }

    public function cancel () :void {
        if (_slot != null) {
            _slot.remove();
            _slot = null;
        }
    }

    public function once () :EventRegistration {
        _once = true;
        return this;
    }

    protected function onSignalDispatch (...args) :void {
        var f :Function = _f;
        if (_once) {
            cancel();
        }
        f.apply(null, args);
    }

    protected var _slot :ISlot;
    protected var _f :Function;
    protected var _once :Boolean;
}
