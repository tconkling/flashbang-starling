//
// flashbang

package flashbang.resource {

import flash.utils.ByteArray;

import aspire.util.ClassUtil;

import flump.display.Library;
import flump.display.LibraryLoader;
import flump.executor.Executor;
import flump.executor.Future;

public class FlumpLibraryLoader extends ResourceLoader
{
    /** The name of the Library (required) */
    public static const NAME :String = "name";

    /**
     * a String containing a URL to load the Library from OR
     * a ByteArray containing the Library OR
     * an [Embed]ed class containing the Library data
     * (required)
     */
    public static const DATA :String = "data";

    public function FlumpLibraryLoader (params :Object) {
        super(params);
    }

    override protected function doLoad () :void {
        _name = requireLoadParam(NAME, String);
        var data :Object = requireLoadParam(DATA, Object);
        if (data is Class) {
            var clazz :Class = Class(data);
            data = ByteArray(new clazz());
        }

        _exec = new Executor();
        _exec.succeeded.add(function (f :Future) :void {
            libraryLoaded(f.result);
        });
        _exec.failed.add(function (f :Future) :void {
            fail(f.result);
        });

        if (data is ByteArray) {
            LibraryLoader.loadBytes(ByteArray(data), _exec);

        } else if (data is String) {
            LibraryLoader.loadURL(data as String, _exec);

        } else {
            throw new Error("Unrecognized Flump Library data source: '" +
                ClassUtil.tinyClassName(data) + "'");
        }
    }

    protected function libraryLoaded (library :Library) :void {
        var resources :Vector.<Resource> = new <Resource>[];

        // create a (private) resource for the library itself
        resources.push(new LibraryResource(_name, library));

        // create individual resources for each symbol in the library
        for each (var movieName :String in library.movieSymbols) {
            resources.push(new MovieResource(library, _name, movieName));
        }
        for each (var imageName :String in library.imageSymbols) {
            resources.push(new ImageResource(library, _name, imageName));
        }

        succeed(resources);
    }

    override protected function onLoadCanceled () :void {
        _exec.shutdownNow();
        _exec = null;
    }

    protected var _name :String;
    protected var _exec :Executor;
}
}

import flump.display.Library;

import flashbang.resource.Resource;

class LibraryResource extends Resource {
    public function LibraryResource (name :String, lib :Library) {
        super(name);
        _lib = lib;
    }

    override protected function unload () :void {
        _lib.dispose();
        _lib = null;
    }

    protected var _lib :Library;
}
