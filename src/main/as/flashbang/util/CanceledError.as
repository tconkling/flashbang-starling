//
// aciv

package flashbang.util {

/** When a CancelableProcess is cancelled, its result fails with a CanceledError */
public class CanceledError extends Error {
    public function CanceledError () {
        super("Canceled");
    }

    public function toString () :String {
        return "CanceledError";
    }
}
}
