//
// flashbang

package flashbang.util {

import flash.events.ErrorEvent;
import flash.events.UncaughtErrorEvent;

public class Errors
{
    /** Generates a message string from an arbitrary error object */
    public static function getMessage (error :*) :String {
        return getMessageInternal(error, true);
    }

    /** Generates a shorter message string from an arbitrary error object */
    public static function getShortMessage (error :*) :String {
        return getMessageInternal(error, false);
    }

    protected static function getMessageInternal (error :*, wantStackTrace :Boolean) :String {
        // NB: do NOT use the class-cast operator for converting to typed error objects.
        // Error() is a top-level function that creates a new error object, rather than performing
        // a class-cast, as expected.

        var msg :String;
        if (error is Error) {
            var e :Error = (error as Error);
            if (wantStackTrace) {
                msg = e.getStackTrace();
                if (msg != null && msg.length > 0) {
                    return msg;
                }
            }

            msg = e.message;
            if (msg != null && msg.length > 0) {
                return msg;
            }
        } else if (error is UncaughtErrorEvent) {
            return getMessageInternal(error.error, wantStackTrace);

        } else if (error is ErrorEvent) {
            var ee :ErrorEvent = (error as ErrorEvent);
            msg = ee.text;
            if (msg != null && msg.length > 0) {
                return msg;
            }
        }

        return "An error occurred: " + error;

    }
}
}
