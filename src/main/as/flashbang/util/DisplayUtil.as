//
// flashbang

package flashbang.util {

import aspire.geom.Vector2;
import aspire.util.F;

import flash.geom.Point;

import flashbang.core.Flashbang;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Quad;
import starling.display.Sprite;

public class DisplayUtil
{
    /** Returns a stage-sized rectangle filled with the given color */
    public static function fillStageRect (color :uint = 0, alpha :Number = 1) :Quad {
        var r :Quad = fillRect(Flashbang.stageWidth, Flashbang.stageHeight, color);
        r.alpha = alpha;
        return r;
    }

    /** Returns a rectangle filled with the given color */
    public static function fillRect (width :Number, height :Number, color :uint) :Quad {
        return new Quad(width, height, color);
    }

    /** Returns a rectangle outlined with the given color */
    public static function lineRect (width :Number, height :Number, color :uint, lineSize :Number) :Sprite {
        return outlineFillRect(width, height, 0, lineSize, color);
    }

    /** Returns a rectangle filled and outlined with the given colors */
    public static function outlineFillRect (width :Number, height :Number, fillColor :uint,
        outlineSize :Number, outlineColor :uint) :Sprite {

        var sprite :Sprite = new Sprite();
        if (fillColor != 0) {
            sprite.addChild(fillRect(width, height, fillColor));
        }

        var top :Quad = fillRect(width, outlineSize, outlineColor);
        var bottom :Quad = fillRect(width, outlineSize, outlineColor);
        var left :Quad = fillRect(outlineSize, height, outlineColor);
        var right :Quad = fillRect(outlineSize, height, outlineColor);

        bottom.y = height - outlineSize;
        right.x = width - outlineSize;

        sprite.addChild(top);
        sprite.addChild(bottom);
        sprite.addChild(left);
        sprite.addChild(right);

        return sprite;
    }

    /** Transforms a point from one DisplayObject's coordinate space to another's. */
    public static function transformPoint (p :Point, from :DisplayObject, to :DisplayObject,
        out :Point = null) :Point
    {
        return to.globalToLocal(from.localToGlobal(p, P), out);
    }

    /** Transforms a Vector2 from one DisplayObject's coordinate space to another's. */
    public static function transformVector (v :Vector2, from :DisplayObject, to :DisplayObject,
        out :Vector2 = null) :Vector2
    {
        return Vector2.fromPoint(transformPoint(v.toPoint(P), from, to, P), out);
    }

    /** Adds newChild to container, directly below another child of the container. */
    public static function addChildBelow (container :DisplayObjectContainer,
        newChild :DisplayObject,
        below :DisplayObject) :void
    {
        container.addChildAt(newChild, container.getChildIndex(below));
    }

    /** Adds newChild to container, directly above another child of the container. */
    public static function addChildAbove (container :DisplayObjectContainer,
        newChild :DisplayObject,
        above :DisplayObject) :void
    {
        container.addChildAt(newChild, container.getChildIndex(above) + 1);
    }

    /**
     * Changes the DisplayObject's index in its parent container so that it's layered behind
     * all its siblings.
     */
    public static function moveToBack (disp :DisplayObject) :void {
        var parent :DisplayObjectContainer = disp.parent;
        if (parent != null) {
            parent.setChildIndex(disp, 0);
        }
    }

    /**
     * Changes the DisplayObject's index in its parent container so that it's layered in front of
     * all its siblings.
     */
    public static function moveToFront (disp :DisplayObject) :void {
        var parent :DisplayObjectContainer = disp.parent;
        if (parent != null) {
            parent.setChildIndex(disp, parent.numChildren - 1);
        }
    }

    /** Removes disp from its parent, and adds replacement at the same index */
    public static function replaceInParent (disp :DisplayObject, replacement :DisplayObject,
        dispose :Boolean = false) :void {

        var parent :DisplayObjectContainer = disp.parent;
        if (parent != null) {
            var idx :int = parent.getChildIndex(disp);
            parent.removeChildAt(idx, dispose);
            parent.addChildAt(replacement, idx);
        }
    }

    /**
     * Call <code>callback</code> for <code>disp</code> and all its descendants.
     *
     * @param disp the root of the hierarchy at which to start the iteration
     * @param callback function to call for each node in the display tree for disp. The passed
     * object will never be null and the function will be called exactly once for each node, unless
     * iteration is halted. The callback can have one of four signatures:
     * <listing version="3.0">
     *     function callback (disp :DisplayObject) :void
     *     function callback (disp :DisplayObject) :Boolean
     *     function callback (disp :DisplayObject, depth :int) :void
     *     function callback (disp :DisplayObject, depth :int) :Boolean
     * </listing>
     *
     * If <code>callback</code> returns <code>true</code>, traversal will halt.
     *
     * The passed in depth is 0 for <code>disp</code>, and increases by 1 for each level of
     * children.
     *
     * @return <code>true</code> if <code>callback</code> returned <code>true</code>
     */
    public static function walkDisplayObjects (root :DisplayObject, callback :Function,
        maxDepth :int = int.MAX_VALUE) :Boolean {
        return walkDisplayObjectsImpl(root, maxDepth, F.adapt(callback), 0);
    }

    /** Helper for applyToHierarchy */
    protected static function walkDisplayObjectsImpl (root :DisplayObject, maxDepth :int,
        callback :Function, depth :int) :Boolean {
        // halt traversal if callbackFunction returns true
        if (Boolean(callback(root, depth))) {
            return true;
        }

        if (++depth > maxDepth || !(root is DisplayObjectContainer)) {
            return false;
        }
        var container :DisplayObjectContainer = DisplayObjectContainer(root);
        var nn :int = container.numChildren;
        for (var ii :int = 0; ii < nn; ii++) {
            var child :DisplayObject = container.getChildAt(ii);
            if (walkDisplayObjectsImpl(child, maxDepth, callback, depth)) {
                return true;
            }
        }

        return false;
    }

    protected static const P :Point = new Point();
}
}
