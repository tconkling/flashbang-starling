//
// aciv

package flashbang.resource {

import flump.display.Library;

public class FlumpLibraryResource extends Resource {
    public static function createResources (name :String, library :Library) :Vector.<Resource> {
        var resources :Vector.<Resource> = new <Resource>[];

        // create a (private) resource for the library itself
        resources[resources.length] = new FlumpLibraryResource(name, library);

        // create individual resources for each symbol in the library
        for each (var movieName :String in library.movieSymbols) {
            resources[resources.length] = new MovieResource(library, name, movieName);
        }
        for each (var imageName :String in library.imageSymbols) {
            resources[resources.length] = new ImageResource(library, name, imageName);
        }

        return resources;
    }

    public function FlumpLibraryResource (name :String, lib :Library) {
        super(name);
        _lib = lib;
    }

    public function get lib () :Library {
        return _lib;
    }

    override protected function dispose () :void {
        _lib.dispose();
        _lib = null;
    }

    private var _lib :Library;
}

}
