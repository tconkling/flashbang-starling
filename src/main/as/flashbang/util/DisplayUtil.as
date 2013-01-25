//
// flashbang

package flashbang.util {

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
        sprite.flatten();
        
        return sprite;
    }
}
}
