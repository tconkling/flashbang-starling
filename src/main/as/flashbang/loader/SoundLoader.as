//
// aciv

package flashbang.loader {

import aspire.util.F;
import aspire.util.Log;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.media.Sound;
import flash.net.URLRequest;

import flashbang.util.CancelableProcess;
import flashbang.util.CanceledError;

import react.Future;
import react.NumberValue;
import react.NumberView;
import react.Promise;

public class SoundLoader implements CancelableProcess {
    public static function load (url :String) :CancelableProcess {
        var loader :SoundLoader = new SoundLoader(url);
        loader.begin();
        return loader;
    }

    /**
     * @param url the URL to load the sound from
     * @param isStreaming if true, the loader will complete immediately after the load begins.
     */
    public function SoundLoader (url :String, isStreaming :Boolean = false) {
        _url = url;
        _isStreaming = isStreaming;
    }

    /** @return Future<Sound> */
    public function get result () :Future {
        return _result;
    }

    public function get progress () :NumberView {
        return _progress;
    }

    public function begin () :Future {
        if (!_began) {
            _began = true;
            _sound = new Sound();
            _sound.addEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
            _sound.addEventListener(ProgressEvent.PROGRESS, onProgress);

            if (!_isStreaming) {
                // Streaming sounds will complete as soon as they get any progress
                _sound.addEventListener(Event.COMPLETE, F.bind(onSoundReady));
            }

            try {
                _sound.load(new URLRequest(_url));
            } catch (error :Error) {
                _result.fail(error);
                return _result;
            }
        }
        return _result;
    }

    public function close () :void {
        if (!_result.isComplete.value && _sound != null) {
            try {
                _sound.close();
            } catch (err :Error) {
                // swallow
            }
            _sound = null;
            _result.fail(new CanceledError());
        }
    }

    protected function onSoundReady () :void {
        _result.succeed(_sound);
    }

    protected function onErrorEvent (e :Event) :void {
        if (!_result.isComplete.value) {
            _result.fail(e);
        } else {
            log.warning("Got an error on an already-loaded sound",
                "url", _url, "isStreaming", _isStreaming, e);
        }
    }

    protected function onProgress (e :ProgressEvent) :void {
        if (_isStreaming && !_result.isComplete.value) {
            _progress.value = 1;
            onSoundReady();
        } else if (!_isStreaming) {
            _progress.value = (e.bytesLoaded / e.bytesTotal);
        }
    }

    protected const _result :Promise = new Promise();
    protected const _progress :NumberValue = new NumberValue();

    protected var _url :String;
    protected var _isStreaming :Boolean;
    protected var _sound :Sound;
    protected var _began :Boolean;

    protected static const log :Log = Log.getLog(SoundLoader);
}
}
