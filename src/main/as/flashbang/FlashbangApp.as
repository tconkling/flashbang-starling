//
// Flashbang

package flashbang {

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.system.Capabilities;
import flash.system.TouchscreenType;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.RectangleUtil;

import aspire.util.Arrays;
import aspire.util.Map;
import aspire.util.Maps;
import aspire.util.Preconditions;

import flashbang.audio.AudioManager;
import flashbang.resource.ResourceManager;
import flashbang.util.ListenerRegistrations;

import org.osflash.signals.Signal;

public class FlashbangApp extends flash.display.Sprite
{
    public const didShutdown :Signal = new Signal();

    public function FlashbangApp ()
    {
        // Start starling when we're added to the stage
        addEventListener(flash.events.Event.ADDED_TO_STAGE, addedToStage);
        Flashbang.registerApp(this);
    }

    /**
     * Call this function before the application shuts down to release
     * memory and disconnect event handlers. The app may not shut down
     * immediately when this function is called - if it is running, it will be
     * shut down at the end of the current update.
     *
     * It's an error to continue to use a FlashbangApp that has been shut down.
     *
     * Most applications will want to install an Event.REMOVED_FROM_STAGE
     * handler on the main sprite, and call shutdown from there.
     */
    public function shutdown () :void
    {
        if (_running) {
            _shutdownPending = true;
        } else {
            shutdownNow();
        }
    }

    /**
     * Creates and registers a new Viewport. (Flashbang automatically creates a Viewport on
     * initialization, so this is only necessary for creating additional ones.)
     *
     * Viewports must be uniquely named.
     */
    public function createViewport (name :String,
        parentSprite :starling.display.Sprite = null) :Viewport
    {
        if (parentSprite == null) {
            parentSprite = _mainSprite;
        }

        var viewport :Viewport = new Viewport(this, name, parentSprite);
        var existing :Object = _viewports.put(name, viewport);
        Preconditions.checkState(existing == null, "A viewport with that name already exists",
            "name", name);
        return viewport;
    }

    /**
     * Returns the Viewport with the given name, if it exists.
     */
    public function getViewport (name :String) :Viewport
    {
        return _viewports.get(name);
    }

    /**
     * Returns the default Viewport that was created when Flashbang was initialized
     */
    public function get defaultViewport () :Viewport
    {
        return getViewport(Viewport.DEFAULT);
    }

    public function addUpdatable (obj :Updatable) :void
    {
        _updatables.push(obj);
    }

    public function removeUpdatable (obj :Updatable) :void
    {
        Arrays.removeFirst(_updatables, obj);
    }

    /**
     * Returns the approximate frames-per-second that the application
     * is running at.
     */
    public function get fps () :Number
    {
        return _fps;
    }

    /**
     * Returns the current "time" value, in seconds. This should only be used for the purposes
     * of calculating time deltas, not absolute time, as the implementation may change.
     *
     * We use Date().time, instead of flash.utils.getTimer(), since the latter is susceptible to
     * Cheat Engine speed hacks:
     * http://www.gaminggutter.com/forum/f16/how-use-cheat-engine-speedhack-games-2785.html
     */
    public function getAppTime () :Number
    {
        return (new Date().time * 0.001); // convert millis to seconds
    }

    /** Subclasses can override this to create a custom Config */
    protected function getConfig () :Config
    {
        return new Config();
    }

    /** Subclasses should override this to push their initial AppMode to the mode stack */
    protected function run () :void
    {
    }

    /** Initializes Starling and creates the _starling instance */
    protected function initStarling () :void
    {
        var iOS :Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
        var isMac :Boolean = Capabilities.manufacturer.indexOf("Macintosh") != -1;
        var hasTouchscreen :Boolean = (Capabilities.touchscreenType == TouchscreenType.FINGER);

        Starling.multitouchEnabled = hasTouchscreen;

        // per Starling: Macs and iOS don't require this
        Starling.handleLostContext = !(isMac || iOS);

        var viewPort :Rectangle = RectangleUtil.fit(
            new Rectangle(0, 0, _config.stageWidth, _config.stageHeight),
            new Rectangle(0, 0, _config.windowWidth, _config.windowHeight));

        _starling = new Starling(starling.display.Sprite, this.stage, viewPort);
        _starling.stage.stageWidth = _config.stageWidth;
        _starling.stage.stageHeight = _config.stageHeight;
        _starling.enableErrorChecking = Capabilities.isDebugger;
    }

    protected function addedToStage (e :flash.events.Event) :void
    {
        _config = getConfig();

        initStarling();
        _regs.addOneShotEventListener(_starling, starling.events.Event.ROOT_CREATED, rootCreated);
        _starling.start();
    }

    protected function rootCreated (..._) :void
    {
        _audio = new AudioManager(_config.maxAudioChannels);
        addUpdatable(_audio);

        _mainSprite = starling.display.Sprite(_starling.root);

        // Create our default viewport
        createViewport(Viewport.DEFAULT);

        _regs.addEventListener(_mainSprite, starling.events.Event.ENTER_FRAME, update);
        _lastTime = getAppTime();

        run();

        _viewports.forEach(function (name :String, viewport :Viewport) :void {
            viewport.handleModeTransitions();
        });
    }

    protected function update (e :starling.events.Event) :void
    {
        // how much time has elapsed since last frame?
        var newTime :Number = getAppTime();
        var dt :Number = newTime - _lastTime;

        if (_config.minFrameRate > 0) {
            // Ensure that our time deltas don't get too large
            dt = Math.min(1.0 / _config.minFrameRate, dt);
        }

        _fps = 1.0 / dt;

        // update all our "updatables"
        for each (var updatable :Updatable in _updatables) {
            updatable.update(dt);
        }

        // update our viewports
        // we iterate the values Array so that we can safely removed destroyed Viewports
        for each (var viewport :Viewport in _viewports.values()) {
            if (!viewport.isDestroyed) {
                viewport.update(dt);
            }
            if (viewport.isDestroyed) {
                _viewports.remove(viewport.name);
                viewport.shutdown();
            }
        }

        // should the MainLoop be stopped?
        if (_shutdownPending) {
            _running = false;
            _regs.cancel();
            shutdownNow();
        }

        _lastTime = newTime;
    }

    protected function shutdownNow () :void
    {
        _viewports.forEach(function (name :String, viewport :Viewport) :void {
            viewport.shutdown();
        });
        _viewports = null;

        _mainSprite = null;
        _updatables = null;

        _regs.cancel();
        _regs = null;

        _audio.shutdown();
        _rsrcs.shutdown();

        didShutdown.dispatch();
    }

    internal var _rsrcs :ResourceManager = new ResourceManager();
    internal var _audio :AudioManager;
    internal var _starling :Starling;
    internal var _config :Config;

    protected var _mainSprite :starling.display.Sprite;
    protected var _regs :ListenerRegistrations = new ListenerRegistrations();

    protected var _running :Boolean;
    protected var _shutdownPending :Boolean;
    protected var _lastTime :Number;
    protected var _updatables :Array = [];
    protected var _viewports :Map = Maps.newMapOf(String); // <String, Viewport>
    protected var _fps :Number = 0;
}

}
