//
// aciv

package flashbang.util {

import react.Registration;

/** A process that can be canceled via Registration.close() */
public interface CancelableProcess extends Process, Registration {
}

}
