//
// flashbang

package flashbang.resource {

import flashbang.loader.BatchLoader;
import flashbang.loader.XmlLoader;

import starling.text.BitmapFont;

public class FontResourceLoader extends ResourceLoader
{
    /** The name of the Font (required) */
    public static const NAME :String = "name";

    /**
     * a String containing a URL to load the XML from OR
     * a ByteArray containing the XML OR
     * an [Embed]ed class containing the XML
     * (required)
     */
    public static const XML_DATA :String = "xmlData";

    /**
     * a String containing a URL to load the texture BitmapData from from OR
     * a ByteArray containing the BitmapData OR
     * a Class that will instantiate a Bitmap
     * (required)
     */
    public static const TEXTURE_DATA :String = "textureData";

    /** The scale of the font texture (optional, @default 1) */
    public static const SCALE :String = "scale";

    public function FontResourceLoader (params :Object) {
        super(params);
    }

    override protected function doLoad () :void {
        var name :String = requireLoadParam(NAME, String);

        var xmlLoader :XmlLoader = new XmlLoader(requireLoadParam(XML_DATA));
        var textureLoader :TextureLoader =
            new TextureLoader(requireLoadParam(TEXTURE_DATA), getLoadParam(SCALE, 1));

        _batch = new BatchLoader();
        _batch.addLoader(xmlLoader);
        _batch.addLoader(textureLoader);
        _batch.load().onSuccess(function () :void {
            var rsrc :FontResource;
            try {
                var texture :LoadedTexture = textureLoader.result;
                var xml :XML = xmlLoader.result;
                var font :BitmapFont = new BitmapFont(texture.texture, xml);
                rsrc = new FontResource(name, font);
            } catch (e :Error) {
                fail(e);
                return;
            }

            succeed(rsrc);

        }).onFailure(fail);
    }

    override protected function onCanceled () :void {
        if (_batch != null) {
            _batch.close();
            _batch = null;
        }
    }

    protected var _batch :BatchLoader;
}
}

import aspire.util.ClassUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import flash.utils.ByteArray;

import flashbang.loader.DataLoader;

import starling.textures.Texture;

class LoadedTexture
{
    public function LoadedTexture (source :*, scale :Number) {
        _source = source;

        var bmd :BitmapData;
        if (source is Loader) {
            bmd = Bitmap(Loader(source).content).bitmapData;
        } else if (source is Bitmap) {
            bmd = Bitmap(source).bitmapData;
        } else {
            throw new Error("Unknown texture source [" + ClassUtil.tinyClassName(source) + "]");
        }
        _tex = Texture.fromBitmapData(bmd, false, false, scale);

        // Keep the source open so that Starling can handle a context loss
    }

    public function get texture () :Texture {
        return _tex;
    }

    public function unload () :void {
        _tex.dispose();
        _tex = null;
        closeSource();
    }

    protected function closeSource () :void {
        // source may already be closed.
        if (_source == null) {
            return;
        }

        if (_source is Loader) {
            try {
                Loader(_source).close();
            } catch (e :Error) {
                // swallow
            }
        } else if (_source is Bitmap) {
            Bitmap(_source).bitmapData.dispose();
        }
        _source = null;
    }

    protected var _tex :Texture;
    protected var _source :*;
}

class TextureLoader extends DataLoader
{
    public function TextureLoader (data :Object, scale :Number) {
        _data = data;
        _scale = scale;
    }

    override protected function doLoad () :void {
        if (_data is Class) {
            var clazz :Class = Class(_data);
            _data = new clazz();
        }

        if (_data is Bitmap) {
            succeed(new LoadedTexture(_data, _scale));
            return;
        }

        _loader = new Loader();

        _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,
            function (evt :IOErrorEvent) :void {
                fail(evt);
            });

        _loader.contentLoaderInfo.addEventListener(Event.INIT, function (..._) :void {
            try {
                succeed(new LoadedTexture(_loader, _scale));
                _loader = null;
            } catch (e :Error) {
                fail(e);
            }
        });

        if (_data is String) {
            _loader.load(new URLRequest(_data as String));
        } else if (_data is ByteArray) {
            _loader.loadBytes(_data as ByteArray);
        } else {
            throw new Error("Unrecognized Texture data source: '" +
                ClassUtil.tinyClassName(_data) + "'");
        }
    }

    override protected function onCanceled () :void {
        // Loader may already be closed.
        if (_loader != null) {
            try {
                _loader.close();
            } catch (e :Error) {
                // swallow
            }
            _loader = null;
        }
    }

    protected var _data :Object;
    protected var _scale :Number;
    protected var _loader :Loader;
}
