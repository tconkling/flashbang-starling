//
// aciv

package flashbang.core {

public interface Renderable
{
    /**
     * Prepare this object for rendering.
     *
     * Renderable objects will have their render() function called after all objects
     * have been updated, making this a useful place for display logic that depends on update logic
     * having completed.
     *
     * In general, game state should *not* be changed from within a willRender() function.
     *
     * (This interface is optional - objects don't need to implement Renderable in order
     * to be drawn.)
     */
    function willRender () :void;
}
}
