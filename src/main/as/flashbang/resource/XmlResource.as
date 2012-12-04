//
// flashbang

package flashbang.resource {

import flash.errors.IOError;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;

import aspire.util.XmlUtil;

import flashbang.Flashbang;

public class XmlResource extends Resource
{
    /** Load params */

    /** A String containing the URL to load the XML from.
     * (URL, BYTES, EMBEDDED_CLASS or TEXT must be specified). */
    public static const URL :String = "url";

    /** A ByteArray containing the XML.
     * (URL, BYTES, EMBEDDED_CLASS or TEXT must be specified). */
    public static const BYTES :String = "bytes";

    /** The [Embed]'d class to load the XML from.
     * (URL, BYTES, EMBEDDED_CLASS or TEXT must be specified). */
    public static const EMBEDDED_CLASS :String = "embeddedClass";

    /** A String containing the XML.
     * (URL, BYTES, EMBEDDED_CLASS or TEXT must be specified). */
    public static const TEXT :String = "text";

    public static function createFactory () :ResourceFactory
    {
        return new XmlFactory();
    }

    public static function get (name :String) :XML
    {
        var rsrc :XmlResource = Flashbang.rsrcs.getResource(name);
        return (rsrc != null ? rsrc.result : null);
    }

    public static function require (name :String) :XML
    {
        return Flashbang.rsrcs.requireResource(name, XmlResource).result;
    }

    public function XmlResource (name :String, params :Object)
    {
        super(name, params);
    }

    override protected function doLoad () :void
    {
        if (hasLoadParam(URL)) {
            loadFromURL(getLoadParam(URL));

        } else if (hasLoadParam(EMBEDDED_CLASS)) {
            var clazz :Class = getLoadParam(EMBEDDED_CLASS);
            var ba :ByteArray = ByteArray(new clazz());
            createXml(ba.readUTFBytes(ba.length));

        } else if (hasLoadParam(BYTES)) {
            var bytes :ByteArray = getLoadParam(BYTES);
            createXml(bytes.readUTFBytes(bytes.length));

        } else if (hasLoadParam(TEXT)) {
            createXml(getLoadParam(TEXT));

        } else {
            throw new Error("'url', 'embeddedClass', 'bytes', or 'text' must be specified in " +
                "loadParams");
        }
    }

    protected function loadFromURL (urlString :String) :void
    {
        var loader :URLLoader = new URLLoader();
        loader.dataFormat = URLLoaderDataFormat.TEXT;
        loader.addEventListener(Event.COMPLETE, function (..._) :void {
            var data :* = loader.data;
            loader.close();
            createXml(data);
        });

        loader.addEventListener(IOErrorEvent.IO_ERROR, function (e :IOErrorEvent) :void {
            fail(new IOError(e.text, e.errorID));
        });

        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
            function (e :SecurityErrorEvent) :void {
                fail(new SecurityError(e.text, e.errorID));
            });

        loader.load(new URLRequest(urlString));
    }

    protected function createXml (data :*) :void
    {
        // override the default XML settings, so we get the full text content
        var settings :Object = XML.defaultSettings();
        settings["ignoreWhitespace"] = false;
        settings["prettyPrinting"] = false;
        succeed(XmlUtil.newXML(data, settings));
    }
}
}

import flashbang.resource.Resource;
import flashbang.resource.ResourceFactory;
import flashbang.resource.XmlResource;

class XmlFactory
    implements ResourceFactory
{
    public function create (name :String, params :Object) :Resource
    {
        return new XmlResource(name, params);
    }
}
