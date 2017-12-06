//
// flashbang

package flashbang.resource {

import aspire.util.ClassUtil;

import flashbang.loader.XMLDataLoader;

public class XmlResourceLoader extends ResourceLoader
{
    /** Load params */

    /** The name of the XML resource (required) */
    public static const NAME :String = "name";

    /**
     * a String containing a URL to load the XML from OR
     * a ByteArray containing the XML OR
     * an [Embed]ed class containing the XML
     * (required)
     */
    public static const DATA :String = "data";

    public function XmlResourceLoader (params :Object) {
        super(params);
    }

    override protected function doLoad () :void {
        var name :String = requireLoadParam(NAME, String);

        _loader = new XMLDataLoader(requireLoadParam(DATA, Object));
        _loader.load().onSuccess(function (result :XML) :void {
            succeed(new XmlResource(name, result));
        }).onFailure(fail);
    }

    override protected function onCanceled () :void {
        if (_loader != null) {
            _loader.close();
            _loader = null;
        }
    }

    public function toString () :String {
        return getLoadParam(NAME) + " (" + ClassUtil.tinyClassName(this) + ")";
    }

    protected var _loader :XMLDataLoader;
}
}
