//
// flashbang

package flashbang.util {

import react.Registration;

public interface EventRegistration extends Registration
{
    function once () :EventRegistration;
}
}
