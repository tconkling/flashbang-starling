//
// Flashbang

package flashbang.util {

import flash.events.IEventDispatcher;

import react.RegistrationGroup;

import starling.events.EventDispatcher;

/** Assists with the management of Event listeners */
public class Listeners extends RegistrationGroup
{
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

    public function close () :void {
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
            close();
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

    public function close () :void {
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
            close();
        }
        f(e);
    }

    protected var _dispatcher :IEventDispatcher;
    protected var _type :String;
    protected var _f :Function;
    protected var _once :Boolean;
}
