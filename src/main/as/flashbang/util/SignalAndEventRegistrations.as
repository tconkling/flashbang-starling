//
// Flashbang

package flashbang.util {

import flash.events.Event;

import org.osflash.signals.ISignal;

import starling.events.EventDispatcher;

import aspire.util.Registration;
import aspire.util.RegistrationList;
import aspire.util.Registrations;

public class SignalAndEventRegistrations extends RegistrationList
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
     * @return a Registration object that will disconnect the listener from the EventDispatcher.
     */
    public function addEventListener (dispatcher :EventDispatcher, type :String, l :Function) :Registration
    {
        dispatcher.addEventListener(type, l);
        return add(Registrations.createWithFunction(function () :void {
            dispatcher.removeEventListener(type, l);
        }));
    }

    /**
     * Adds a listener to the specified EventDispatcher for the specified event type.
     * It will be removed after being dispatched once.
     * @return a Registration object that will disconnect the listener from the EventDispatcher.
     */
    public function addOneShotEventListener (dispatcher :EventDispatcher, type :String,
        l :Function) :Registration
    {
        var eventListener :Function = function (e :Event) :void {
            dispatcher.removeEventListener(type, l);
            l(e);
        };

        return addEventListener(dispatcher, type, eventListener);
    }
}
}
