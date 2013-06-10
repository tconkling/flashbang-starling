//
// flashbang

package flashbang.util {

import aspire.util.Registration;

public interface EventRegistration extends Registration
{
    function once () :EventRegistration;
}
}
