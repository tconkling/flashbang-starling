//
// Flashbang

package flashbang.util {

import flash.events.Event;
import flash.events.IEventDispatcher;

import org.osflash.signals.ISignal;

import starling.events.Event;
import starling.events.EventDispatcher;

import aspire.util.Registration;
import aspire.util.RegistrationList;
import aspire.util.Registrations;

public class ListenerRegistrations extends RegistrationList
{
    /**
     * Adds a listener to the specified signal.
     * @return a Registration object that will disconnect the listener from the signal.
     */
    public function addSignalListener (signal :ISignal, l :Function) :Registration
    {
        signal.add(l);
        return add(Registrations.createWithFunction(function () :void {
            signal.remove(l);
        }));
    }

    /**
     * Adds a listener to the specified signal. It will be removed after being dispatched once.
     * @return a Registration object that will disconnect the listener from the signal.
     */
    public function addOneShotSignalListener (signal :ISignal, l :Function) :Registration
    {
        signal.addOnce(l);
        return add(Registrations.createWithFunction(function () :void {
            signal.remove(l);
        }));
    }

    /**
     * Adds a listener to the specified EventDispatcher for the specified event type.
     * Note: this works with both Starling and Flash EventDispatchers.
     * @return a Registration object that will disconnect the listener from the EventDispatcher.
     */
    public function addEventListener (dispatcher :Object, type :String, l :Function) :Registration
    {
        if (dispatcher is IEventDispatcher) {
            return addFlashEventListener(IEventDispatcher(dispatcher), type, l);
        } else {
            return addStarlingEventListener(EventDispatcher(dispatcher), type, l);
        }
    }

    /**
     * Adds a listener to the specified EventDispatcher for the specified event type.
     * It will be removed after being dispatched once.
     * Note: this works with both Starling and Flash EventDispatchers.
     * @return a Registration object that will disconnect the listener from the EventDispatcher.
     */
    public function addOneShotEventListener (dispatcher :Object, type :String,
        l :Function) :Registration
    {
        if (dispatcher is IEventDispatcher) {
            return addOneShotFlashEventListener(IEventDispatcher(dispatcher), type, l);
        } else {
            return addOneShotStarlingEventListener(EventDispatcher(dispatcher), type, l);
        }
    }

    protected function addFlashEventListener (dispatcher :IEventDispatcher, type :String,
        l :Function) :Registration
    {
        dispatcher.addEventListener(type, l);
        return add(Registrations.createWithFunction(function () :void {
            dispatcher.removeEventListener(type, l);
        }));
    }

    protected function addStarlingEventListener (dispatcher :EventDispatcher, type :String,
        l :Function) :Registration
    {
        dispatcher.addEventListener(type, l);
        return add(Registrations.createWithFunction(function () :void {
            dispatcher.removeEventListener(type, l);
        }));
    }

    protected function addOneShotFlashEventListener (dispatcher :IEventDispatcher, type :String,
        l :Function) :Registration
    {
        var eventListener :Function = function (e :flash.events.Event) :void {
            dispatcher.removeEventListener(type, l);
            l(e);
        };
        return addFlashEventListener(dispatcher, type, eventListener);
    }

    protected function addOneShotStarlingEventListener (dispatcher :EventDispatcher, type :String,
        l :Function) :Registration
    {
        var eventListener :Function = function (e :starling.events.Event) :void {
            dispatcher.removeEventListener(type, l);
            l(e);
        };
        return addStarlingEventListener(dispatcher, type, eventListener);
    }
}
}
