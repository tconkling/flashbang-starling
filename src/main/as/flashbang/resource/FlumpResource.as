//
// flashbang

package flashbang.resource {

import flashbang.core.Flashbang;

import flump.display.Library;

import starling.display.DisplayObject;

/** Base class for resources loaded from a Flump Library */
public /*abstract*/ class FlumpResource extends Resource
{
    /**
     * Creates a DisplayObject from the FlumpResource with the given name.
     * Throws an error if the resource doesn't exist.
     */
    public static function createDisplayObject (name :String) :DisplayObject {
        var rsrc :FlumpResource = Flashbang.rsrcs.requireResource(name);
        return rsrc.createDisplayObject();
    }

    /** Returns the FlumpResource with the given name, or null if it doesn't exist */
    public static function get (name :String) :FlumpResource {
        return Flashbang.rsrcs.getResource(name);
    }

    /** Returns the FlumpResource with the given name. Throws an Error if it doesn't exist. */
    public static function require (name :String) :FlumpResource {
        return Flashbang.rsrcs.requireResource(name);
    }

    public function FlumpResource (library :Library, libraryName :String, symbolName :String) {
        super(libraryName + "/" + symbolName);
        _library = library;
        _symbolName = symbolName;
    }

    public function createDisplayObject () :DisplayObject {
        throw new Error("abstract");
    }

    override protected function dispose () :void {
        _library = null;
    }

    protected var _library :Library;
    protected var _symbolName :String;
}
}

