//
// flashbang

package flashbang.util {

import aspire.geom.Vector2;
import aspire.util.F;
import aspire.util.MathUtil;

import flash.geom.Point;
import flash.geom.Rectangle;

import flashbang.core.Flashbang;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Touch;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.RectangleUtil;

public class DisplayUtil
{
    /**
     * Inserts a DisplayObject into a DisplayObjectContainer at its proper sorted location.
     * The DisplayObjectContainer must already be in the sort order defined by the given
     * comparator function for this to operate correctly.
     *
     * @return the index that the DisplayObject was inserted at.
     */
    public static function sortedInsert (container :DisplayObjectContainer, disp :DisplayObject, comp :Function) :int {
        var low :int = 0;
        var high :int = container.numChildren - 1;
        var insertIdx :int = -1;
        while (low <= high) {
            // http://googleresearch.blogspot.com/2006/06/extra-extra-read-all-about-it-nearly.html
            var mid :int = (low + high) >>> 1;
            var midDisp :DisplayObject = container.getChildAt(mid);
            var cmp :int = comp(midDisp, disp);
            if (cmp < 0) {
                low = mid + 1;
            } else if (cmp > 0) {
                high = mid - 1;
            } else {
                insertIdx = mid;
                break;
            }
        }

        if (insertIdx < 0) {
            insertIdx = low;
        }

        container.addChildAt(disp, insertIdx);
        return insertIdx;
    }

    /**
     * Draws a "three-brush" image into a Sprite.
     * A three-brush is composed of three textures: left, center, and middle. The center image
     * is tiled as many times as is necessary to fill the given width.
     */
    public static function drawThreeBrush (
        l :Texture, c :Texture, r :Texture, w :Number,
        x :Number = 0, y :Number = 0, sprite :Sprite = null) :Sprite {

        if (sprite == null) {
            sprite = new Sprite();
        }

        // left
        var left :Image = new Image(l);
        left.x = x;
        left.y = y;
        sprite.addChild(left);

        // right
        var right :Image = new Image(r);
        right.x = x + w - r.width;
        right.y = y;
        sprite.addChild(right);

        // tile the middle
        var remaining :Number = w - l.width - r.width;
        x += l.width;
        while (remaining > 0) {
            var tileWidth :Number = Math.min(c.width, remaining);
            var tile :Image = new Image(clampTexWidth(c, tileWidth));
            tile.x = x;
            tile.y = y;
            sprite.addChild(tile);

            x += tileWidth;
            remaining -= tileWidth;
        }

        return sprite;
    }

    /**
     * Draws a "three-brush" image into a Sprite.
     * The center image will be stretched, rather than tiled, to fill the given width.
     */
    public static function drawStretchedThreeBrush (
        l :Texture, c :Texture, r :Texture, w :Number,
        x :Number = 0, y :Number = 0, sprite :Sprite = null) :Sprite {

        if (sprite == null) {
            sprite = new Sprite();
        }

        // left
        var left :Image = new Image(l);
        left.x = x;
        left.y = y;
        sprite.addChild(left);

        // right
        var right :Image = new Image(r);
        right.x = x + w - r.width;
        right.y = y;
        sprite.addChild(right);

        // center
        var remaining :Number = w - l.width - r.width;
        if (remaining > 0) {
            var center :Image = new Image(c);
            center.width = remaining;
            center.x = l.width;
            sprite.addChild(center);
        }

        return sprite;
    }

    /**
     * Draws a "nine-brush" image into a Sprite.
     * A nine-brush is composed of 9 textures: 3 for the top, 3 for the middle, and 3 for the bottom.
     * Each set of 3 textures is used to draw three-brushes for the top, middle, and bottom of
     * the image.
     */
    public static function drawNineBrush (
        tl :Texture, tc :Texture, tr :Texture,
        ml :Texture, mc :Texture, mr :Texture,
        bl :Texture, bc :Texture, br :Texture,
        w :Number, h :Number,
        x :Number = 0, y :Number = 0, sprite :Sprite = null) :Sprite {

        if (sprite == null) {
            sprite = new Sprite();
        }

        // top
        drawThreeBrush(tl, tc, tr, w, x, y, sprite);

        // bottom
        drawThreeBrush(bl, bc, br, w, x, y + h - bl.height, sprite);

        // tile the middle
        var remaining :Number = h - tl.height - bl.height;
        y += tl.height;
        while (remaining > 0) {
            var rowHeight :Number = Math.min(ml.height, remaining);
            drawThreeBrush(
                clampTexHeight(ml, rowHeight),
                clampTexHeight(mc, rowHeight),
                clampTexHeight(mr, rowHeight),
                w, x, y, sprite);

            y += rowHeight;
            remaining -= rowHeight;
        }

        return sprite;
    }

    /** Clamps the given texture's width. */
    public static function clampTexWidth (tex :Texture, width :Number) :Texture {
        return clampTexSize(tex, width, tex.height);
    }

    /** Clamps the given texture's height. */
    public static function clampTexHeight (tex :Texture, height :Number) :Texture {
        return clampTexSize(tex, tex.width, height);
    }

    /** Clamps the given texture's width and height. */
    public static function clampTexSize (tex :Texture, width :Number, height :Number) :Texture {
        if (tex.width == width && tex.height == height) {
            return tex;
        } else {
            R.setTo(0, 0, width, height);
            return Texture.fromTexture(tex, R);
        }
    }

    /** Returns the global/stage location of the given displayObject */
    public static function getGlobalLoc (d :DisplayObject, out :Point = null) :Point {
        P.setTo(d.x, d.y);
        return d.localToGlobal(P, out);
    }

    /** Returns true if potentialAncestor is an ancestor of the given DisplayObect on the display list */
    public static function isAncestor (d :DisplayObject, potentialAncestor :DisplayObject) :Boolean {
        while (d.parent != null) {
            if (d.parent == potentialAncestor) {
                return true;
            }
            d = d.parent;
        }
        return false;
    }

    /** Performs a hit test on the given DisplayObject for the given Touch */
    public static function hitTestTouch (d :DisplayObject, t :Touch) :DisplayObject {
        P.setTo(t.globalX, t.globalY);
        return d.hitTest(d.globalToLocal(P, P));
    }

    /** Positions a DisplayObject so that it is centered on another DisplayObject */
    public static function center (disp :DisplayObject, relativeTo :DisplayObject,
        xOffset :Number = 0, yOffset :Number = 0) :void {
        DisplayUtil.positionRelative(disp, Align.CENTER, Align.CENTER,
            relativeTo, Align.CENTER, Align.CENTER, xOffset, yOffset);
    }

    /** Positions a DisplayObject in relation to another DisplayObject */
    public static function positionRelative (
        disp :DisplayObject,
        dispHAlign :String, dispVAlign :String,
        relativeTo :DisplayObject,
        targetHAlign :String, targetVAlign :String,
        xOffset :Number = 0, yOffset :Number = 0) :void {

        positionRelativeImpl(disp,
            dispHAlign, dispVAlign,
            relativeTo.getBounds(disp.parent || relativeTo, R),
            targetHAlign, targetVAlign,
            xOffset, yOffset);
    }

    /** Positions a DisplayObject relative to the screen */
    private static const SCREEN_BOUNDS :Rectangle = new Rectangle();
    public static function positionRelativeToStage (
        disp :DisplayObject,
        dispHAlign :String, dispVAlign :String,
        targetHAlign :String, targetVAlign :String,
        xOffset :Number = 0, yOffset :Number = 0) :void {

        SCREEN_BOUNDS.setTo(0, 0, Flashbang.stageWidth, Flashbang.stageHeight);
        if (disp.parent != null) {
            RectangleUtil.getBounds(SCREEN_BOUNDS, disp.parent.transformationMatrix, SCREEN_BOUNDS);
        }

        positionRelativeImpl(disp,
            dispHAlign, dispVAlign,
            SCREEN_BOUNDS,
            targetHAlign, targetVAlign,
            xOffset, yOffset);
    }

    /** Returns a stage-sized rectangle filled with the given color */
    public static function fillStageRect (color :uint = 0, alpha :Number = 1) :Quad {
        var r :Quad = fillRect(Flashbang.stageWidth, Flashbang.stageHeight, color);
        r.alpha = alpha;
        return r;
    }

    /** Returns a rectangle filled with the given color */
    public static function fillRect (width :Number, height :Number, color :uint, alpha :Number = 1) :Quad {
        var r :Quad = new Quad(width, height, color);
        r.alpha = alpha;
        return r;
    }

    /** Returns a rectangle outlined with the given color */
    public static function lineRect (width :Number, height :Number, color :uint, lineSize :Number, alpha :Number = 1) :Sprite {
        return outlineFillRectImpl(width, height, 0, lineSize, color, false, alpha);
    }

    /** Returns a rectangle filled and outlined with the given colors */
    public static function outlineFillRect (width :Number, height :Number, fillColor :uint,
        outlineSize :Number, outlineColor :uint, alpha :Number = 1) :Sprite {
        return outlineFillRectImpl(width, height, fillColor, outlineSize, outlineColor, true, alpha);
    }

    /** Transforms a point from one DisplayObject's coordinate space to another's. */
    public static function transformPoint (p :Point, from :DisplayObject, to :DisplayObject,
        out :Point = null) :Point {
        return to.globalToLocal(from.localToGlobal(p, P), out);
    }

    /** Transforms a Vector2 from one DisplayObject's coordinate space to another's. */
    public static function transformVector (v :Vector2, from :DisplayObject, to :DisplayObject,
        out :Vector2 = null) :Vector2 {
        return Vector2.fromPoint(transformPoint(v.toPoint(P), from, to, P), out);
    }

    /** Transforms a Rectangle from one DisplayObject's coordinate space to another's. */
    public static function transformRect (r :Rectangle, from :DisplayObject, to :DisplayObject,
        out :Rectangle = null) :Rectangle {

        var left :Number = Number.MAX_VALUE;
        var top :Number = Number.MAX_VALUE;
        var right :Number = -Number.MAX_VALUE;
        var bottom :Number = -Number.MAX_VALUE;

        // top-left
        P.setTo(r.left, r.top);
        transformPoint(P, from, to, P);
        left = MathUtil.min(left, P.x);
        right = MathUtil.max(right, P.x);
        top = MathUtil.min(top, P.y);
        bottom = MathUtil.max(bottom, P.y);

        // top-right
        P.setTo(r.right, r.top);
        transformPoint(P, from, to, P);
        left = MathUtil.min(left, P.x);
        right = MathUtil.max(right, P.x);
        top = MathUtil.min(top, P.y);
        bottom = MathUtil.max(bottom, P.y);

        // bottom-left
        P.setTo(r.left, r.bottom);
        transformPoint(P, from, to, P);
        left = MathUtil.min(left, P.x);
        right = MathUtil.max(right, P.x);
        top = MathUtil.min(top, P.y);
        bottom = MathUtil.max(bottom, P.y);

        // bottom-right
        P.setTo(r.right, r.bottom);
        transformPoint(P, from, to, P);
        left = MathUtil.min(left, P.x);
        right = MathUtil.max(right, P.x);
        top = MathUtil.min(top, P.y);
        bottom = MathUtil.max(bottom, P.y);

        if (out == null) {
            out = new Rectangle();
        }
        out.setTo(left, top, right - left, bottom - top);
        return out;
    }

    /** Adds newChild to container, directly below another child of the container. */
    public static function addChildBelow (container :DisplayObjectContainer,
        newChild :DisplayObject, below :DisplayObject) :void {
        container.addChildAt(newChild, container.getChildIndex(below));
    }

    /** Adds newChild to container, directly above another child of the container. */
    public static function addChildAbove (container :DisplayObjectContainer,
        newChild :DisplayObject, above :DisplayObject) :void {
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

    protected static function positionRelativeImpl (
        disp :DisplayObject,
        dispHAlign :String, dispVAlign :String,
        relativeTo :Rectangle,
        targetHAlign :String, targetVAlign :String,
        xOffset :Number, yOffset :Number) :void {

        var x :Number = xOffset;
        var y :Number = yOffset;

        switch (targetHAlign) {
        case Align.LEFT: x += relativeTo.left; break;
        case Align.RIGHT: x += relativeTo.right; break;
        case Align.CENTER: x += relativeTo.left + (relativeTo.width * 0.5); break;
        }
        switch (targetVAlign) {
        case Align.TOP: y += relativeTo.top; break;
        case Align.BOTTOM: y += relativeTo.bottom; break;
        case Align.CENTER: y += relativeTo.top + (relativeTo.height * 0.5); break;
        }

        disp.x = 0;
        disp.y = 0;
        var dispBounds :Rectangle = disp.getBounds(disp.parent, R); // works when parent is null
        switch (dispHAlign) {
        case Align.LEFT: x -= dispBounds.left; break;
        case Align.RIGHT: x -= dispBounds.right; break;
        case Align.CENTER: x -= dispBounds.left + (dispBounds.width * 0.5); break;
        }
        switch (dispVAlign) {
        case Align.TOP: y -= dispBounds.top; break;
        case Align.BOTTOM: y -= dispBounds.bottom; break;
        case Align.CENTER: y -= dispBounds.top + (dispBounds.height * 0.5); break;
        }

        disp.x = x;
        disp.y = y;
    }

    /** Returns a rectangle filled and outlined with the given colors */
    protected static function outlineFillRectImpl (width :Number, height :Number, fillColor :uint,
        outlineSize :Number, outlineColor :uint, fill :Boolean, alpha :Number) :Sprite {

        var sprite :Sprite = new Sprite();
        if (fill) {
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

        sprite.alpha = alpha;

        return sprite;
    }

    /** Helper for walkDisplayObjects */
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

    private static const P :Point = new Point();
    private static const R :Rectangle = new Rectangle();
}
}
