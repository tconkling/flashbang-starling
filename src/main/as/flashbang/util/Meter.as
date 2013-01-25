//
// flashbang

package flashbang.util {

public interface Meter
{
    function get maxValue () :Number;
    function set maxValue (val :Number) :void;
    
    function get minValue () :Number;
    function set minValue (val :Number) :void;
    
    function get value () :Number;
    function set value (val :Number) :void;
}
}
