//
// flashbang

package flashbang.input {

public interface DragHandlerBuilder
{
    function onDragged (f :Function) :DragHandlerBuilder;
    function onDragEnd (f :Function) :DragHandlerBuilder;
    function build () :DragHandler;
}

}
