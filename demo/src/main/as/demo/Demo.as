//
// Flashbang Demo

package demo {

import flashbang.FlashbangApp;

[SWF(width="320", height="480", frameRate="60", backgroundColor="#222222")]
public class Demo extends FlashbangApp
{
    override protected function run () :void
    {
        // Load our assets. LoadingMode will kick off the game when it's finished.
        this.defaultViewport.pushMode(new LoadingMode());
    }
}

}

import aspire.util.Log;

import flashbang.AppMode;
import flashbang.resource.ResourceSet;

import demo.GameMode;

class LoadingMode extends AppMode
{
    public function LoadingMode ()
    {
        var resources :ResourceSet = new ResourceSet();
        resources.add("flump", { name: "flump", embeddedClass: FLUMP });
        resources.load(
            function () :void {
                // resources loaded. kick off the game.
                viewport.changeMode(new GameMode());
            },
            function (e :Error) :void {
                // there was a load error
                log.error("Error loading resources", e);
            });
    }

    protected static const log :Log = Log.getLog(LoadingMode);

    [Embed(source="../../../../rsrc/flump.zip", mimeType="application/octet-stream")]
    protected static const FLUMP :Class;
}
