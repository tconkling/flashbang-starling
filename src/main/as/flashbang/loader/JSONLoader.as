//
// aciv

package flashbang.loader {

import flash.net.URLLoaderDataFormat;

/** Loads JSON from a URL */
public class JSONLoader extends AbstractURLLoader {
    public static function load (url :String, timeout :Number = -1) :LoadProcess {
        return new JSONLoader(url, timeout);
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
