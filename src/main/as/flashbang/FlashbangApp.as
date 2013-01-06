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
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.utils.RectangleUtil;

import aspire.util.F;
import aspire.util.Registration;
import aspire.util.Registrations;

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
     */
    public function shutdown () :void
    {
        _shutdownPending = true;
    }

    /** Called when the app receives touches. By default it forwards them to each viewport */
    public function handleTouches (touches :Vector.<Touch>) :void
    {
        for (var ii :int = _viewports.length - 1; ii >= 0; --ii) {
            _viewports[ii].handleTouches(touches);
        }
    }

    /** Called when the app receives a keyDown event. By default it forwards it to each viewport */
    public function onKeyDown (e :KeyboardEvent) :void
    {
        for (var ii :int = _viewports.length - 1; ii >= 0; --ii) {
            _viewports[ii].onKeyDown(e);
        }
    }

    /** Called when the app receives a keyUp event. By default it forwards it to each viewport */
    public function onKeyUp (e :KeyboardEvent) :void
    {
        for (var ii :int = _viewports.length - 1; ii >= 0; --ii) {
            _viewports[ii].onKeyUp(e);
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

        for each (var existing :Viewport in _viewports) {
            if (existing.name == name) {
                throw new Error("A viewport named '" + name + "' already exists");
            }
        }

        var viewport :Viewport = new Viewport(this, name, parentSprite);
        _viewports.push(viewport);
        return viewport;
    }

    /**
     * Returns the Viewport with the given name, if it exists.
     */
    public function getViewport (name :String) :Viewport
    {
        for each (var viewport :Viewport in _viewports) {
            if (viewport.name == name) {
                return viewport;
            }
        }
        return null;
    }

    /**
     * Returns the default Viewport that was created when Flashbang was initialized
     */
    public function get defaultViewport () :Viewport
    {
        return getViewport(Viewport.DEFAULT);
    }

    public function addUpdatable (obj :Updatable) :Registration
    {
        _updatables.push(obj);
        return Registrations.createWithFunction(F.callback(removeUpdatable, obj));
    }

    public function removeUpdatable (obj :Updatable) :void
    {
        for (var ii :int = _updatables.length - 1; ii >= 0; --ii) {
            if (_updatables[ii] == obj) {
                _updatables.splice(ii, 1);
                break;
            }
        }
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

    protected final function get starling () :Starling
    {
        return _starling;
    }

    protected final function get config () :Config
    {
        return _config;
    }

    /** Subclasses can override this to create a custom Config */
    protected function createConfig () :Config
    {
        return new Config();
    }

    /** Subclasses should override this to push their initial AppMode to the mode stack */
    protected function run () :void
    {
    }

    /**
     * Creates and returns a Starling instance.
     * Subclasses can override to do custom initialization.
     */
    protected function initStarling () :Starling
    {
        var viewPort :Rectangle = RectangleUtil.fit(
            new Rectangle(0, 0, _config.stageWidth, _config.stageHeight),
            new Rectangle(0, 0, _config.windowWidth, _config.windowHeight));

        var starling :Starling = new Starling(starling.display.Sprite, this.stage, viewPort);
        starling.stage.stageWidth = _config.stageWidth;
        starling.stage.stageHeight = _config.stageHeight;
        starling.enableErrorChecking = Capabilities.isDebugger;

        return starling;
    }

    protected function addedToStage (e :flash.events.Event) :void
    {
        var iOS :Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
        var isMac :Boolean = Capabilities.manufacturer.indexOf("Macintosh") != -1;
        var hasTouchscreen :Boolean = (Capabilities.touchscreenType == TouchscreenType.FINGER);

        Starling.multitouchEnabled = hasTouchscreen;

        // per Starling: Macs and iOS don't require this
        Starling.handleLostContext = !(isMac || iOS);

        _config = createConfig();

        _starling = initStarling();
        // install our custom touch handler
        _starling.touchHandler = new AppTouchHandler(handleTouches);
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

        _regs.addEventListener(_mainSprite.stage, KeyboardEvent.KEY_DOWN, onKeyDown);
        _regs.addEventListener(_mainSprite.stage, KeyboardEvent.KEY_UP, onKeyUp);
        _regs.addEventListener(_mainSprite.stage, starling.events.Event.ENTER_FRAME, update);
        _lastTime = getAppTime();

        run();

        for (var ii :int = _viewports.length - 1; ii >= 0; --ii) {
            _viewports[ii].handleModeTransitions();
        }
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

        // update all our updatables
        for each (var updatable :Updatable in _updatables) {
            updatable.update(dt);
        }

        // update viewports
        for (var ii :int = _viewports.length - 1; ii >= 0; --ii) {
            var viewport :Viewport = _viewports[ii];
            if (!viewport.isDestroyed) {
                viewport.update(dt);
            }
            if (viewport.isDestroyed) {
                _viewports.splice(ii, 1);
                viewport.shutdown();
            }
        }

        // should the MainLoop be stopped?
        if (_shutdownPending) {
            _regs.cancel();
            shutdownNow();
        }

        _lastTime = newTime;
    }

    protected function shutdownNow () :void
    {
        for each (var viewport :Viewport in _viewports) {
            viewport.shutdown();
        }
        _viewports = null;

        _mainSprite = null;
        _updatables = null;

        _regs.cancel();
        _regs = null;

        _audio.shutdown();
        _audio = null;

        _rsrcs.shutdown();
        _rsrcs = null;

        _starling.dispose();
        _starling = null;

        didShutdown.dispatch();
    }

    internal var _rsrcs :ResourceManager = new ResourceManager();
    internal var _audio :AudioManager;
    internal var _starling :Starling;
    internal var _config :Config;

    protected var _mainSprite :starling.display.Sprite;
    protected var _regs :ListenerRegistrations = new ListenerRegistrations();

    protected var _shutdownPending :Boolean;
    protected var _lastTime :Number;
    protected var _updatables :Vector.<Updatable> = new <Updatable>[];
    protected var _viewports :Vector.<Viewport> = new <Viewport>[];
    protected var _fps :Number = 0;
}

}

import starling.events.Touch;
import starling.events.TouchHandler;

class AppTouchHandler
    implements TouchHandler
{
    public function AppTouchHandler (f :Function) { _f = f; }
    public function handleTouches (touches :Vector.<Touch>) :void { _f(touches); }
    public function dispose () :void {}

    protected var _f :Function;
}
