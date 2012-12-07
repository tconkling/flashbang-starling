//
// flashbang

package flashbang.resource {

import flash.utils.ByteArray;

import executor.Executor;
import executor.Future;

import flump.display.Library;
import flump.display.LibraryLoader;

public class FlumpLibraryLoader extends ResourceLoader
{
    /** The name of the Library */
    public static const NAME :String = "name";

    /** A String containing the URL to load the Library from.
     * (URL, BYTES, or EMBEDDED_CLASS must be specified). */
    public static const URL :String = "url";

    /** A ByteArray containing the Library.
     * (URL, BYTES, or EMBEDDED_CLASS or TEXT must be specified). */
    public static const BYTES :String = "bytes";

    /** The [Embed]'d class to load the Library from.
     * (URL, BYTES, or EMBEDDED_CLASS or TEXT must be specified). */
    public static const EMBEDDED_CLASS :String = "embeddedClass";

    public function FlumpLibraryLoader (params :Object)
    {
        super(params);
    }

    override protected function doLoad () :void
    {
        _name = requireLoadParam(NAME, String);

        _exec = new Executor();
        _exec.succeeded.add(function (f :Future) :void {
            libraryLoaded(f.result);
        });
        _exec.failed.add(function (f :Future) :void {
            fail(f.result);
        });

        if (hasLoadParam(EMBEDDED_CLASS)) {
            var clazz :Class = requireLoadParam(EMBEDDED_CLASS, Class);
            LibraryLoader.loadBytes(ByteArray(new clazz()), _exec);

        } else if (hasLoadParam(BYTES)) {
            LibraryLoader.loadBytes(requireLoadParam(BYTES, ByteArray), _exec);

        } else if (hasLoadParam(URL)) {
            LibraryLoader.loadURL(requireLoadParam(URL, String), _exec);

        } else {
            throw new Error("'url', 'bytes', or 'embeddedClass' must be specified");
        }
    }

    protected function libraryLoaded (library :Library) :void
    {
        var resources :Array = [];

        // create individual resources for each symbol in the library
        for each (var movieName :String in library.movieSymbols) {
            resources.push(new MovieResource(library, _name, movieName));
        }
        for each (var imageName :String in library.imageSymbols) {
            resources.push(new ImageResource(library, _name, imageName));
        }

        succeed(resources);
    }

    override protected function onLoadCanceled () :void
    {
        _exec.shutdownNow();
        _exec = null;
    }

    protected var _name :String;
    protected var _exec :Executor;
}
}
