//
// aciv

package flashbang.loader {

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import flash.utils.ByteArray;

import flashbang.util.CancelableProcess;
import flashbang.util.CanceledError;

import react.Future;
import react.NumberValue;
import react.NumberView;
import react.Promise;

/** Loads a BitmapData */
public class BitmapLoader implements CancelableProcess {
    public static function load (urlOrByteArray :*) :Future {
        return new BitmapLoader(urlOrByteArray).begin();
    }

    public function BitmapLoader (urlOrByteArray :*) {
        if (urlOrByteArray is String) {
            _url = urlOrByteArray;
        } else if (urlOrByteArray is ByteArray) {
            _bytes = urlOrByteArray;
        } else {
            throw new Error("Unrecognized data source");
        }
    }

    /** @return Future<BitmapData> */
    public function get result () :Future {
        return _result;
    }

    public function get progress () :NumberView {
        return _progress;
    }

    public function begin () :Future {
        if (_began) {
            return _result;
        }
        _began = true;

        _loader = new Loader();
        _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
        _loader.contentLoaderInfo.addEventListener(Event.INIT, function (e :Event) :void {
            var bitmap :Bitmap = Bitmap(_loader.content);
            onBitmapLoaded(bitmap.bitmapData);
        });

        try {
            if (_url != null) {
                _loader.load(new URLRequest(_url));
            } else {
                _loader.loadBytes(_bytes);
            }
        } catch (e :Error) {
            _result.fail(e);
        }

        return _result;
    }

    public function close () :void {
        if (!_result.isComplete.value && _loader != null) {
            try {
                _loader.close();
            } catch (err :Error) {
                // swallow
            }
            _loader = null;
            _result.fail(new CanceledError());
        }
    }

    protected function onBitmapLoaded (bmd :BitmapData) :void {
        _result.succeed(bmd);
    }

    protected function onErrorEvent (e :Event) :void {
        if (!_result.isComplete.value) {
            _result.fail(e);
        }
    }

    protected const _result :Promise = new Promise();
    protected const _progress :NumberValue = new NumberValue();

    protected var _url :String;
    protected var _bytes :ByteArray;
    protected var _began :Boolean;
    protected var _loader :Loader;
}
}
