//
// Flashbang

package flashbang.loader {

import flash.errors.IOError;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;

public class UrlLoader extends DataLoader
{
    public function UrlLoader (request :URLRequest, dataFormat :String = null) {
        _request = request;
        _format = (dataFormat || URLLoaderDataFormat.TEXT);
    }

    override protected function doLoad () :void {
        _loader = new URLLoader();
        _loader.dataFormat = _format;

        _loader.addEventListener(Event.COMPLETE, function (..._) :void {
            var data :* = _loader.data;
            _loader = null;
            succeed(data);
        });

        _loader.addEventListener(IOErrorEvent.IO_ERROR, function (e :IOErrorEvent) :void {
            fail(new IOError(e.text, e.errorID));
        });

        _loader.load(_request);
    }

    override protected function onLoadCanceled () :void {
        // Loader may already be closed.
        if (_loader != null) {
            try {
                _loader.close();
            } catch (e :Error) {
                // swallow
            }
            _loader = null;
        }
    }

    protected var _request :URLRequest;
    protected var _format :String;
    protected var _loader :URLLoader;
}
}
