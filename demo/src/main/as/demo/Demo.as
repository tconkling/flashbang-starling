//
// Flashbang Demo

package demo {

import flashbang.core.FlashbangApp;
import flashbang.core.FlashbangConfig;

[SWF(width="480", height="320", frameRate="60", backgroundColor="#222222")]
public class Demo extends FlashbangApp
{
    public static const WIDTH :int = 480;
    public static const HEIGHT :int = 320;

    override protected function run () :void {
        // Load our assets. LoadingMode will kick off the game when it's finished.
        _modeStack.pushMode(new LoadingMode());
    }

    override protected function createConfig () :FlashbangConfig {
        var config :FlashbangConfig = new FlashbangConfig();
        config.stageWidth = WIDTH;
        config.stageHeight = HEIGHT;
        config.windowWidth = WIDTH;
        config.windowHeight = HEIGHT;
        return config;
    }
}

}

import aspire.util.Log;

import demo.GameMode;

import flashbang.core.AppMode;
import flashbang.resource.ResourceSet;

class LoadingMode extends AppMode
{
    public function LoadingMode () {
        var resources :ResourceSet = new ResourceSet();
        resources.add({ type: "flump", name: "flump", data: FLUMP });
        resources.load()
            .onSuccess(function () :void {
                // resources loaded. kick off the game.
                _modeStack.changeMode(new GameMode());
            })
            .onFailure(function (e :Error) :void {
                // there was a load error
                log.error("Error loading resources", e);
            });
    }

    protected static const log :Log = Log.getLog(LoadingMode);

    [Embed(source="../../../../rsrc/flump.zip", mimeType="application/octet-stream")]
    protected static const FLUMP :Class;
}
