//
// flashbang

package flashbang.resource {

import aspire.util.ClassUtil;

import flash.system.System;

import flashbang.loader.TextureLoader;
import flashbang.loader.XMLLoader;
import flashbang.util.BatchProcess;

import react.Executor;

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

        var xmlURL :String = Params.require(params, XML_URL, String);
        var imageURL :String = Params.require(params, IMAGE_URL, String);
        var imageScale :Number = Params.get(params, SCALE, 1);

        _batch = new BatchProcess()
            .add(new XMLLoader(xmlURL))
            .add(new TextureLoader(imageURL, imageScale));

        _result = _batch.result.map(function (results :Array) :FontResource {
            var xml :XML = results[0];
            var tex :Texture = results[1];
            var font :BitmapFont = new BitmapFont(tex, xml);
            System.disposeXML(xml);
            return new FontResource(_name, font);
        });
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

    public function executor (exec :Executor) :void {
        if (!_began) {
            _batch.executor(exec);
        }
    }

    public function begin () :Future {
        if (!_began) {
            _began = true;
            _batch.begin();
        }

        return _result;
    }

    public function toString () :String {
        return _name + " (" + ClassUtil.tinyClassName(this) + ")";
    }

    protected var _name :String;

    protected var _result :Future;
    protected var _batch :BatchProcess;
    protected var _began :Boolean;
}
}
