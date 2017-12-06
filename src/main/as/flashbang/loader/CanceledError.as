//
// aciv

package flashbang.loader {

/** When a LoadProcess is cancelled, its result fails with a CanceledError */
public class CanceledError extends Error {
    public function CanceledError () {
        super("Canceled");
    }

    public function toString () :String {
        return "CanceledError";
    }
}
}
