//
// Flashbang

package flashbang.loader {

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.Timer;

public class UrlDataLoader extends DataLoader
{
    public function UrlDataLoader (request :URLRequest, dataFormat :String = null,
            loadTimeout :Number = -1) {
        _request = request;
        _format = (dataFormat || URLLoaderDataFormat.TEXT);
        _loadTimeout = loadTimeout;
    }

    override protected function doLoad () :void {
        _loader = new URLLoader();
        _loader.dataFormat = _format;
        _loader.addEventListener(Event.COMPLETE, onLoadComplete);
        _loader.addEventListener(IOErrorEvent.IO_ERROR, fail);
        _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fail);

        if (_loadTimeout > 0) {
            _timeoutTimer = new Timer(_loadTimeout * 1000, 1);

            // any activity on the load indicates we can stop waiting for a timeout
            _loader.addEventListener(ProgressEvent.PROGRESS, shutdownTimeoutTimer);
            _timeoutTimer.addEventListener(TimerEvent.TIMER, timeout);

            _timeoutTimer.start();
        }

        _loader.load(_request);
    }

    protected function shutdownLoader () :void {
        if (_loader != null) {
            try {
                _loader.close();
            } catch (e :Error) {
                // swallow
            }
            _loader = null;
        }
    }

    protected function shutdownTimeoutTimer (...ignored) :void {
        if (_timeoutTimer != null) {
            _timeoutTimer.stop();
            _timeoutTimer = null;
        }
    }

    protected function timeout (e :Event) :void {
        fail(new TimeoutErrorEvent(TimeoutErrorEvent.TIMEOUT,
            "URLLoader timed out [url=" + _request.url + ", timeout=" + _loadTimeout + "]"));
    }

    override protected function onCanceled () :void {
        shutdownTimeoutTimer();
        shutdownLoader();
    }

    override public function fail (cause :Object) :void {
        shutdownTimeoutTimer();
        shutdownLoader();
        super.fail(cause);
    }

    protected function onLoadComplete (e :Event) :void {
        var data :* = _loader.data;
        _loader = null;
        shutdownTimeoutTimer();
        // don't need to shutdown loader
        succeed(data);
    }

    protected var _request :URLRequest;
    protected var _format :String;
    protected var _loader :URLLoader;

    protected var _loadTimeout :Number;
    protected var _timeoutTimer :Timer;
}
}
