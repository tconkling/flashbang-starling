//
// aciv

package flashbang.loader {

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.utils.Timer;

import flashbang.util.CancelableProcess;
import flashbang.util.CanceledError;

import react.Future;
import react.NumberValue;
import react.NumberView;
import react.Promise;

public class URLDataLoader implements CancelableProcess {
    public function URLDataLoader (url :String, dataFormat :String, timeout :Number = -1) {
        _url = url;
        _timeout = timeout;
        _dataFormat = dataFormat;
    }

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
        _loader = new URLLoader();
        _loader.dataFormat = _dataFormat;
        _loader.addEventListener(Event.COMPLETE, onComplete);
        _loader.addEventListener(IOErrorEvent.IO_ERROR, fail);
        _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fail);
        _loader.addEventListener(ProgressEvent.PROGRESS, onProgress);

        if (_timeout > 0) {
            _timeoutTimer = new Timer(_timeout * 1000, 1);
            _timeoutTimer.addEventListener(TimerEvent.TIMER, onTimeout);
            _timeoutTimer.start();
        }

        try {
            _loader.load(new URLRequest(_url));
        } catch (e :Error) {
            fail(e);
        }

        return _result;
    }

    public function cancel () :void {
        fail(new CanceledError());
    }

    protected function onComplete (e :Event) :void {
        succeed(_loader.data);
    }

    protected function onProgress (e :ProgressEvent) :void {
        shutdownTimeoutTimer();
        _progress.value = (e.bytesLoaded / e.bytesTotal);
    }

    protected function onTimeout (e :Event) :void {
        fail(new TimeoutErrorEvent(TimeoutErrorEvent.TIMEOUT,
            "URLLoader timed out [url=" + _url + ", timeout=" + _timeout + "]"));
    }

    protected function succeed (data :*) :void {
        if (!_result.isComplete.value) {
            shutdownTimeoutTimer();
            closeLoader();
            _result.succeed(data);
        }
    }

    protected function fail (err :*) :void {
        if (!_result.isComplete.value) {
            shutdownTimeoutTimer();
            closeLoader();
            _result.fail(err);
        }
    }

    protected function shutdownTimeoutTimer () :void {
        if (_timeoutTimer != null) {
            _timeoutTimer.stop();
            _timeoutTimer = null;
        }
    }

    protected function closeLoader () :void {
        if (_loader != null) {
            try {
                _loader.close();
            } catch (err :Error) {
                // swallow;
            }
            _loader = null;
        }
    }

    protected const _result :Promise = new Promise();
    protected const _progress :NumberValue = new NumberValue();

    protected var _url :String;
    protected var _dataFormat :String;
    protected var _timeout :Number;

    protected var _began :Boolean;
    protected var _loader :URLLoader;
    protected var _timeoutTimer :Timer;
}
}
