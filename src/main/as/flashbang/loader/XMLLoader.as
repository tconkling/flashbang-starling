//
// aciv

package flashbang.loader {

import aspire.util.XmlUtil;

import flash.net.URLLoaderDataFormat;

/** Loads XML from a URL */
public class XMLLoader extends AbstractURLLoader {
    public static function load (url :String, timeout :Number = -1) :LoadProcess {
        return new XMLLoader(url, timeout);
    }

    public function XMLLoader (url :String, timeout :Number = -1) {
        super(url, URLLoaderDataFormat.TEXT, timeout);
    }

    override protected function succeed (data :*) :void {
        var xml :XML = null;
        try {
            // override the default XML settings, so we get the full text content
            var settings :Object = XML.defaultSettings();
            settings["ignoreWhitespace"] = false;
            settings["prettyPrinting"] = false;
            xml = XmlUtil.newXML(data, settings);
        } catch (err :Error) {
            fail(new Error("XML parsing failed: " + err.message + " [url=" + _url + "]"));
            return;
        }

        super.succeed(xml);
    }
}
}
