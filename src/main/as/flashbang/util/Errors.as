//
// flashbang

package flashbang.util {

import aspire.util.ClassUtil;
import aspire.util.Joiner;

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

        if (error is Error) {
            var e :Error = (error as Error);
            return (wantStackTrace ? e.getStackTrace() : e.message || "");
        } else if (error is UncaughtErrorEvent) {
            return getMessageInternal(error.error, wantStackTrace);
        } else if (error is ErrorEvent) {
            var ee :ErrorEvent = (error as ErrorEvent);
            var joiner :Joiner = new Joiner(ClassUtil.tinyClassName(ee));
            joiner.add("errorID", ee.errorID);
            joiner.add("type", '"' + ee.type + '"');
            if (ee.text != null && ee.text.length > 0) {
                joiner.add("text", '"' + ee.text + '"');
            }
            return joiner.toString();
        }

        return "An error occurred: " + error;
    }
}
}
