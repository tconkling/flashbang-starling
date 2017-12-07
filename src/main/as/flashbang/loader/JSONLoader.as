//
// aciv

package flashbang.loader {

import flash.net.URLLoaderDataFormat;

import flashbang.util.CancelableProcess;

/** Loads JSON from a URL */
public class JSONLoader extends AbstractURLLoader {
    public static function load (url :String, timeout :Number = -1) :CancelableProcess {
        var loader :JSONLoader = new JSONLoader(url, timeout);
        loader.begin();
        return loader;
    }

    public function JSONLoader (url :String, timeout :Number = -1) {
        super(url, URLLoaderDataFormat.TEXT, timeout);
    }

    override protected function succeed (data :*) :void {
        var json :Object = null;
        try {
            json = JSON.parse(data);
        } catch (err :Error) {
            fail(new Error("JSON parsing failed: " + err.message + " [url=" + _url + "]"));
            return;
        }

        super.succeed(json);
    }
}
}
