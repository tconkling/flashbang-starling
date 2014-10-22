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

import flashbang.util.Listeners;

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

        if (_loadTimeout > 0) {
            _loadTimer = new Timer(_loadTimeout * 1000);

            // any activity on the load indicates we can stop waiting for a timeout
            _loadStartedRegs = new Listeners();
            _loadStartedRegs.addEventListener(_loader, SecurityErrorEvent.SECURITY_ERROR,
                killTimer);
            _loadStartedRegs.addEventListener(_loader, ProgressEvent.PROGRESS, killTimer);
            _loadStartedRegs.addEventListener(_loadTimer, TimerEvent.TIMER, timeout);

            _loadTimer.start();
        }

        _loader.load(_request);
    }

    protected function killTimer (...ignored) :void {
        if (_loadStartedRegs != null) {
            _loadStartedRegs.close();
            _loadStartedRegs = null;
        }
        if (_loadTimer != null) {
            _loadTimer.reset();
            _loadTimer = null;
        }
    }

    protected function timeout (e :Event) :void {
        fail(new IOErrorEvent(TIMEOUT));
    }

    protected function onLoadComplete (e :Event) :void {
        killTimer();
        var data :* = _loader.data;
        _loader = null;
        succeed(data);
    }

    override protected function onCanceled () :void {
        killTimer();
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

    override public function fail (cause :Object) :void {
        super.fail(cause);
        killTimer();
    }

    protected static const TIMEOUT :String = "URLLoader timed out!";

    protected var _request :URLRequest;
    protected var _format :String;
    protected var _loader :URLLoader;

    protected var _loadTimeout :Number;
    protected var _loadStartedRegs :Listeners;
    protected var _loadTimer :Timer;
}
}
