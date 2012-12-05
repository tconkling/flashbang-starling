//
// flashbang

package flashbang.resource {

import flashbang.Flashbang;

public class XmlResource extends Resource
{
    public static function get (name :String) :XML
    {
        var rsrc :XmlResource = Flashbang.rsrcs.getResource(name);
        return (rsrc != null ? rsrc.xml : null);
    }

    public static function require (name :String) :XML
    {
        return Flashbang.rsrcs.requireResource(name, XmlResource).result;
    }

    public function XmlResource (name :String, xml :XML)
    {
        super(name);
        _xml = xml;
    }

    public function get xml () :XML
    {
        return _xml;
    }

    protected var _xml :XML;
}
}
