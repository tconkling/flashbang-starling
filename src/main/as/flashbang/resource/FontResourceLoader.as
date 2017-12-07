//
// flashbang

package flashbang.resource {

import aspire.util.ClassUtil;

import flash.system.System;

import flashbang.loader.TextureLoader;
import flashbang.loader.XMLLoader;
import flashbang.util.BatchProgress;

import react.Future;
import react.NumberView;

import starling.text.BitmapFont;
import starling.textures.Texture;

public class FontResourceLoader implements IResourceLoader {
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

    public function get loadSize () :Number {
        return _batchProgress.totalSize;
    }

    public function get progress () :NumberView {
        return _batchProgress.progress;
    }

    public function get result () :Future {
        return _result;
    }

    public function begin () :Future {
        if (_result != null) {
            return _result;
        }

        var xmlLoader :XMLLoader = new XMLLoader(_xmlURL);
        var texLoader :TextureLoader = new TextureLoader(_imageURL, _imageScale);
        _batchProgress = new BatchProgress();
        _batchProgress.add(xmlLoader);
        _batchProgress.add(texLoader);

        _result = Future.sequence([xmlLoader.begin(), texLoader.begin()])
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

    protected var _batchProgress :BatchProgress;
    protected var _result :Future;
}
}
