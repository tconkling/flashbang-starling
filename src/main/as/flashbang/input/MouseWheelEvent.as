//
// flashbang

package flashbang.input {

public class MouseWheelEvent
{
    public var stageX :Number;
    public var stageY :Number;
    public var wheelDelta :int;

    public function MouseWheelEvent (stageX :Number, stageY :Number, wheelDelta :int) {
        this.stageX = stageX;
        this.stageY = stageY;
        this.wheelDelta = wheelDelta;
    }
}
}
