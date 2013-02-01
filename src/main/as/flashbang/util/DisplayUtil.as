//
// flashbang

package flashbang.util {

import aspire.geom.Vector2;

import flash.geom.Point;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Quad;
import starling.display.Sprite;

public class DisplayUtil
{
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

    protected static const P :Point = new Point();
}
}
