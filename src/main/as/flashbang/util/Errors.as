//
// flashbang

package flashbang.util {

import flash.events.ErrorEvent;

public class Errors
{
    /** Generates a message string from an arbitrary error object */
    public static function getMessage (error :*) :String {
        if (error is Error) {
            return Error(error).getStackTrace();
        } else if (error is ErrorEvent) {
            return ErrorEvent(error).text;
        } else {
            return "An unknown error occurred: " + error;
        }
    }

    /** Generates a shorter message string from an arbitrary error object */
    public static function getShortMessage (error :*) :String {
        if (error is Error) {
            return Error(error).message;
        } else if (error is ErrorEvent) {
            return ErrorEvent(error).text;
        } else {
            return "An unknown error occurred: " + error;
        }
    }
}
}
