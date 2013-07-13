//
// flashbang

package flashbang.input {

public interface PointerListenerBuilder
{
    function onPointerStart (f :Function) :PointerListenerBuilder;
    function onPointerMove (f :Function) :PointerListenerBuilder;
    function onPointerEnd (f :Function) :PointerListenerBuilder;
    function onPointerHover (f :Function) :PointerListenerBuilder;
    function consumeAllTouches (val :Boolean) :PointerListenerBuilder;
    function build () :PointerListener;
}

}
