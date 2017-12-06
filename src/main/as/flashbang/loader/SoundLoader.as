//
// aciv

package flashbang.loader {

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.media.Sound;
import flash.net.URLRequest;

import react.Future;
import react.NumberValue;
import react.NumberView;
import react.Promise;

public class SoundLoader implements LoadProcess {
    public static function load (url :String) :LoadProcess {
        return new SoundLoader(url);
    }

    public function SoundLoader (url :String) {
        _result = new Promise();

        _sound = new Sound();
        _sound.addEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
        _sound.addEventListener(Event.COMPLETE, onComplete);
        _sound.addEventListener(ProgressEvent.PROGRESS, onProgress);

        try {
            _sound.load(new URLRequest(_url));
        } catch (error :Error) {
            _result.fail(error);
        }
    }

    public function get result () :Future {
        return _result;
    }

    public function get progress () :NumberView {
        return _progress;
    }

    public function cancel () :void {
        if (!_result.isComplete.value) {
            try {
                _sound.close();
            } catch (err :Error) {
                // swallow
            }
            _sound = null;
            _result.fail(new CanceledError());
        }
    }

    protected function onComplete (e :Event) :void {
        _result.succeed(_sound);
    }

    protected function onErrorEvent (e :Event) :void {
        if (!_result.isComplete.value) {
            _result.fail(e);
        }
    }

    protected function onProgress (e :ProgressEvent) :void {
        _progress.value = (e.bytesLoaded / e.bytesTotal);
    }

    protected var _url :String;
    protected var _result :Promise;
    protected var _sound :Sound;
    protected var _progress :NumberValue = new NumberValue();
}
}
