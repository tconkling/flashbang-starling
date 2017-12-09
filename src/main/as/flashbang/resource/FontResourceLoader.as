//
// flashbang

package flashbang.resource {

import aspire.util.ClassUtil;

import flash.system.System;

import flashbang.loader.TextureLoader;
import flashbang.loader.XMLLoader;
import flashbang.util.BatchProcess;

import react.Future;
import react.NumberView;

import starling.text.BitmapFont;
import starling.textures.Texture;

public class FontResourceLoader implements ResourceLoader {
    /** The name of the Font (required) */
    public static const NAME :String = "name";

    /** a String containing a URL to load the XML (required) */
    public static const XML_URL :String = "xmlURL";

    /** a String containing a URL to load the texture BitmapData from (required) */
    public static const IMAGE_URL :String = "textureData";

    /** The scale of the font texture (optional, @default 1) */
    public static const SCALE :String = "scale";

    public function FontResourceLoader (params :Object) {
        _name = Params.require(params, NAME, String);
        _xmlURL = Params.require(params, XML_URL, String);
        _imageURL = Params.require(params, IMAGE_URL, String);
        _imageScale = Params.get(params, SCALE, 1);
    }

    public function get processSize () :Number {
        return _batch.processSize;
    }

    public function get progress () :NumberView {
        return _batch.progress;
    }

    public function get result () :Future {
        return _result;
    }

    public function begin () :Future {
        if (_result != null) {
            return _result;
        }

        _batch = new BatchProcess()
            .add(new XMLLoader(_xmlURL))
            .add(new TextureLoader(_imageURL, _imageScale));

        _result = _batch.begin()
            .map(function (results :Array) :FontResource {
                var xml :XML = results[0];
                var tex :Texture = results[1];
                var font :BitmapFont = new BitmapFont(tex, xml);
                System.disposeXML(xml);
                return new FontResource(_name, font);
            });

        return _result;
    }

    public function toString () :String {
        return _name + " (" + ClassUtil.tinyClassName(this) + ")";
    }

    protected var _name :String;
    protected var _xmlURL :String;
    protected var _imageURL :String;
    protected var _imageScale :Number;

    protected var _result :Future;
    protected var _batch :BatchProcess;
}
}
