//
// flashbang

package flashbang.util {

import aspire.geom.Vector2;

import flash.geom.Point;

import starling.display.DisplayObject;
import starling.display.Quad;
import starling.display.Sprite;

public class DisplayUtil
{
    public static function fillRect (width :Number, height :Number, color :uint) :Quad {
        return new Quad(width, height, color);
    }
    
    public static function lineRect (width :Number, height :Number, color :uint, lineSize :Number) :Sprite {
        return outlineFillRect(width, height, 0, lineSize, color);
    }
    
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
    
    protected static const P :Point = new Point();
}
}
