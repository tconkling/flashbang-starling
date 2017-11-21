//
// flashbang

package flashbang.resource {

import flash.system.System;

import flashbang.core.Flashbang;

public class XmlResource extends Resource
{
    /** Returns the XML with the given resource name, or null if it doesn't exist */
    public static function getXml (name :String) :XML {
        var rsrc :XmlResource = Flashbang.rsrcs.getResource(name);
        return (rsrc != null ? rsrc.xml : null);
    }

    /** Returns the XML with the given resource name; throws an error if it doesn't exist */
    public static function requireXml (name :String) :XML {
        return XmlResource(Flashbang.rsrcs.requireResource(name)).xml;
    }

    public function XmlResource (name :String, xml :XML) {
        super(name);
        _xml = xml;
    }

    public function get xml () :XML {
        return _xml;
    }

    override protected function dispose () :void  {
        System.disposeXML(_xml);
        _xml = null;
    }

    protected var _xml :XML;
}
}
