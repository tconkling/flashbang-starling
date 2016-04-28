//
// Flashbang

package flashbang.core {

import aspire.util.F;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.UncaughtErrorEvent;
import flash.geom.Rectangle;
import flash.system.Capabilities;
import flash.system.TouchscreenType;
import flash.ui.Keyboard;
import flash.utils.getTimer;

import flashbang.audio.AudioManager;
import flashbang.input.MouseWheelEvent;
import flashbang.input.TouchInput;
import flashbang.resource.ResourceManager;
import flashbang.util.ErrorScreen;
import flashbang.util.Listeners;

import react.BoolValue;
import react.BoolView;
import react.Registration;
import react.Registrations;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.utils.RectangleUtil;

use namespace flashbang_internal;

public class FlashbangApp extends flash.display.Sprite
{
    public function FlashbangApp () {
        // Start starling when we're added to the stage
        addEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
        Flashbang.registerApp(this);
    }

    public function get disposed () :BoolView {
        return _disposed;
    }

    public function get modeStack () :ModeStack {
        return _modeStack;
    }

    /**
     * Provides a safe mechanism for displaying information about a fatal error and gracefully
     * shutting down.
     */
    public function onFatalError (error :*) :void {
        if (_gotFatalError) {
            // prevent multiple error screens
            return;
        }
        _gotFatalError = true;
        dispose();
        _stage.addChild(new ErrorScreen(_config, error));
    }

    /**
     * Call this function before the application shuts down to release
     * memory and disconnect event handlers. The app may not shut down
     * immediately when this function is called - if it is running, it will be
     * shut down at the end of the current update.
     *
     * It's an error to continue to use a FlashbangApp that has been disposed.
     */
    public function dispose () :void {
        if (!_disposePending && !_disposed.value) {
            if (_isUpdating) {
                _disposePending = true;
            } else {
                disposeNow();
            }
        }
    }

    /** Called when the app receives touches. */
    public function handleTouches (touches :Vector.<Touch>) :void {
        _modeStack.handleTouches(touches);
    }

    /**
     * Called when the app receives a keyboard event.
     */
    public function handleKeyboardEvent (e :KeyboardEvent) :void {
        // TouchInput needs to know whether ctrl or shift is down for TouchEvent dispatching
        if (e.keyCode == Keyboard.CONTROL || e.keyCode == Keyboard.COMMAND) {
            TouchInput._ctrlDown = (e.type == KeyboardEvent.KEY_DOWN);
        } else if (e.keyCode == Keyboard.SHIFT) {
            TouchInput._shiftDown = (e.type == KeyboardEvent.KEY_DOWN);
        }

        _modeStack.handleKeyboardEvent(e);
    }

    /**
     * Called when the app receives a MouseWheelEvent.
     */
    public function handleMouseWheelEvent (e :MouseWheelEvent) :void {
        _modeStack.handleMouseWheelEvent(e);
    }

    public function addUpdatable (obj :Updatable) :Registration {
        _updatables.push(obj);
        return Registrations.createWithFunction(F.bind(removeUpdatable, obj));
    }

    public function removeUpdatable (obj :Updatable) :void {
        var idx :int = _updatables.indexOf(obj);
        if (idx >= 0) {
            _updatables.removeAt(idx);
        }
    }

    /**
     * Returns the current "time" value, in seconds. This should only be used for the purposes
     * of calculating time deltas, not absolute time, as the implementation may change.
     */
    public function get time () :Number {
        return getTimer() * 0.001; // convert millis to seconds

        // Games which are susceptible to "speed hack" exploits may want to override this function
        // to return a value based on Date.
        // See: http://wiki.cheatengine.org/index.php?title=Cheat_Engine:Speedhack
        // return (new Date().time * 0.001); // convert millis to seconds
    }

    public final function get starling () :Starling {
        return _starling;
    }

    protected final function get config () :FlashbangConfig {
        return _config;
    }

    /**
     * Called at the end of the initialization process.
     * Subclasses should override this to push their initial AppMode to the mode stack
     */
    protected function run () :void {
    }

    /** Subclasses can override this to create a custom Config */
    protected function createConfig () :FlashbangConfig {
        return new FlashbangConfig();
    }

    /**
     * Called when we're added to the stage. By default, we immediately begin the initialization
     * process. Subclasses can override this to delay initialization.
     */
    protected function onAddedToStage (e :flash.events.Event) :void {
        initialize();
    }

    /** Begins the initialization process */
    protected function initialize () :void {
        _stage = this.stage;

        // install an uncaught error handler
        this.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,
            onUncaughtErrorEvent);

        _config = createConfig();

        // init Starling. Subclasses can override the starling init params in
        // an initStarling() override
        var isiOS :Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
        var hasTouchscreen :Boolean = (Capabilities.touchscreenType == TouchscreenType.FINGER);
        Starling.multitouchEnabled = hasTouchscreen;
        _starling = createStarling();

        // install our custom touch handler
        _starling.touchProcessor = new CallbackTouchProcessor(_starling.stage, handleTouches);
        _regs.addEventListener(_starling, starling.events.Event.ROOT_CREATED, onStarlingRootCreated).once();
        _starling.start();
    }

    /**
     * Creates and returns a Starling instance.
     * Subclasses can override to do custom initialization.
     */
    protected function createStarling () :Starling {
        var viewPort :Rectangle = RectangleUtil.fit(
            new Rectangle(0, 0, _config.stageWidth, _config.stageHeight),
            new Rectangle(0, 0, _config.windowWidth, _config.windowHeight));

        var starling :Starling = new Starling(starling.display.Sprite, this.stage, viewPort);
        starling.stage.stageWidth = _config.stageWidth;
        starling.stage.stageHeight = _config.stageHeight;
        starling.enableErrorChecking = Capabilities.isDebugger;

        return starling;
    }

    /** Completes the initialization process. */
    protected function onStarlingRootCreated (..._) :void {
        _audio = new AudioManager(_config.maxAudioChannels);
        addUpdatable(_audio);

        _mainSprite = starling.display.Sprite(_starling.root);
        _modeStack = new ModeStack(_mainSprite);

        _regs.addEventListener(_mainSprite.stage, KeyboardEvent.KEY_DOWN, handleKeyboardEvent);
        _regs.addEventListener(_mainSprite.stage, KeyboardEvent.KEY_UP, handleKeyboardEvent);
        _regs.addEventListener(_mainSprite.stage, starling.events.Event.ENTER_FRAME, update);
        _regs.addEventListener(_starling, starling.events.Event.RENDER, render);
        _regs.addEventListener(_starling.nativeStage, MouseEvent.MOUSE_WHEEL, function (e :MouseEvent) :void {
             handleMouseWheelEvent(createMouseWheelEvent(e));
        });
        _lastTime = this.time;

        run();

        _modeStack.handleModeTransitions();
    }

    protected function createMouseWheelEvent (e :MouseEvent) :MouseWheelEvent {
        // convert Flash stage coordinates to Starling stage coordinates
        var stageX :Number = _starling.stage.stageWidth  * (e.stageX - _starling.viewPort.x) / _starling.viewPort.width;
        var stageY :Number = _starling.stage.stageHeight * (e.stageY - _starling.viewPort.y) / _starling.viewPort.height;
        // Flash's mousewheel "down" event deltas bizarrely begin at 0, rather than -1
        var delta :int = (e.delta > 0 ? e.delta : e.delta - 1);
        return new MouseWheelEvent(stageX, stageY, delta);
    }

    protected function update (e :starling.events.Event) :void {
        _isUpdating = true;

        try {
            // how much time has elapsed since last frame?
            var newTime :Number = this.time;
            // prevent negative/zero time updates
            var dt :Number = Math.max(newTime - _lastTime, MIN_UPDATE_DELTA);

            if (_config.maxUpdateDelta > 0) {
                // Ensure that our time deltas don't get too large
                dt = Math.min(_config.maxUpdateDelta, dt);
            }

            // update all our updatables
            for each (var updatable :Updatable in _updatables) {
                updatable.update(dt);
            }

            // update viewports
            _modeStack.update(dt);
            _lastTime = newTime;

        } finally {
            _isUpdating = false;

            // should the MainLoop be stopped?
            if (_disposePending) {
                _regs.close();
                disposeNow();
            }
        }
    }

    protected function render (e :starling.events.Event) :void {
        _modeStack.render();
    }

    /**
     * Called when an UncaughtErrorEvent occurs. By default, the app's onFatalError handler is
     * called with the event's error object.
     */
    protected function onUncaughtErrorEvent (e :UncaughtErrorEvent) :void {
        onFatalError(e);
    }

    protected function disposeNow () :void {
        _modeStack.dispose();

        _mainSprite = null;
        _updatables = null;

        _regs.close();
        _regs = null;

        _audio.dispose();
        _audio = null;

        _rsrcs.dispose();
        _rsrcs = null;

        _starling.dispose();
        _starling = null;

        _disposed.value = true;
    }

    internal var _rsrcs :ResourceManager = new ResourceManager();
    internal var _audio :AudioManager;
    internal var _starling :Starling;
    internal var _config :FlashbangConfig;

    protected var _stage :Stage;
    protected var _mainSprite :starling.display.Sprite;
    protected var _regs :Listeners = new Listeners();

    protected var _isUpdating :Boolean;
    protected var _disposePending :Boolean;
    protected var _disposed :BoolValue = new BoolValue();
    protected var _lastTime :Number;
    protected var _updatables :Vector.<Updatable> = new <Updatable>[];
    protected var _modeStack :ModeStack;

    protected static var _gotFatalError :Boolean;

    protected static const MIN_UPDATE_DELTA :Number = 1 / 120;
}

}

import starling.display.Stage;
import starling.events.Touch;
import starling.events.TouchProcessor;

class CallbackTouchProcessor extends TouchProcessor
{
    public function CallbackTouchProcessor (stage :Stage, f :Function) {
        super(stage);
        _f = f;
    }

    override protected function processTouches (touches :Vector.<Touch>, shiftDown :Boolean, ctrlDown :Boolean) :void {
        // Starling only delivers updated touches to the processTouches function. We want all touches.
        _f(_currentTouches);
    }

    protected var _f :Function;
}
