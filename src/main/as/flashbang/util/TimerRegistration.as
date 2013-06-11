//
// flashbang

package flashbang.util {

import react.Registration;

public interface TimerRegistration extends Registration
{
    function once () :TimerRegistration;
    function start () :TimerRegistration;
    function stop () :TimerRegistration;
}
}
