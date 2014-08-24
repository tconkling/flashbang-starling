//
// flashbang

package flashbang.loader {

import aspire.util.ClassUtil;
import aspire.util.XmlUtil;

import flash.errors.IOError;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;

public class XmlLoader extends DataLoader
{
    /**
     * Creates a new XmlLoader.
     * @source the data source to load the XML from. Can be an embedded Class, a ByteArray,
     * or a String containing a URL.
     */
    public function XmlLoader (source :Object) {
        _source = source;
    }

    override protected function doLoad () :void {
        if (_source is Class) {
            var clazz :Class = Class(_source);
            _source = ByteArray(new clazz());
        }

        if (_source is String) {
            loadFromURL(_source as String);
        } else if (_source is ByteArray) {
            var ba :ByteArray = ByteArray(_source);
            onDataLoaded(ba.readUTFBytes(ba.length));
        } else {
            throw new Error("Unrecognized XML data source: '" +
                ClassUtil.tinyClassName(_source) + "'");
        }
    }

    protected function loadFromURL (urlString :String) :void {
        _loader = new URLLoader();
        _loader.dataFormat = URLLoaderDataFormat.TEXT;
        _loader.addEventListener(Event.COMPLETE, function (..._) :void {
            var data :* = _loader.data;
            _loader.close();
            onDataLoaded(data);
        });

        _loader.addEventListener(IOErrorEvent.IO_ERROR, function (e :IOErrorEvent) :void {
            fail(new IOError(e.text, e.errorID));
        });

        _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
            function (e :SecurityErrorEvent) :void {
                fail(new SecurityError(e.text, e.errorID));
            });

        _loader.load(new URLRequest(urlString));
    }

    protected function onDataLoaded (data :*) :void {
        var xml :XML = null;
        try {
            // override the default XML settings, so we get the full text content
            var settings :Object = XML.defaultSettings();
            settings["ignoreWhitespace"] = false;
            settings["prettyPrinting"] = false;
            xml = XmlUtil.newXML(data, settings);
        } catch (e :Error) {
            fail(e);
            return;
        }

        succeed(xml);
    }

    override protected function onCanceled () :void {
        if (_loader != null) {
            try {
                _loader.close();
            } catch (e :Error) {
                // swallow
            }
            _loader = null;
        }
    }

    protected var _loader :URLLoader;
    protected var _source :Object;
}
}

