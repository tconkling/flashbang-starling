//
// aciv

package flashbang.loader {

import flash.events.ErrorEvent;
import flash.events.Event;

public class TimeoutErrorEvent extends ErrorEvent {
    public static const TIMEOUT :String = "timeout";

    public function TimeoutErrorEvent (type :String, text :String = "", id :int = 0) {
        super(type, false, false, text, id);
    }

    override public function clone () :Event {
        return new TimeoutErrorEvent(this.type, this.text, this.errorID);
    }
}
}
