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
        var msg :String;
        if (error is Error) {
            if (wantStackTrace) {
                msg = error.getStackTrace();
                if (msg != null && msg.length > 0) {
                    return msg;
                }
            }

            msg = error.message;
            if (msg != null && msg.length > 0) {
                return msg;
            }
        } else if (error is UncaughtErrorEvent) {
            return getMessageInternal(error.error, wantStackTrace);

        } else if (error is ErrorEvent) {
            msg = error.text;
            if (msg != null && msg.length > 0) {
                return msg;
            }
        }

        return "An error occurred: " + error;

    }
}
}
