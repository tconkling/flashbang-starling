//
// Flashbang

package flashbang {

import aspire.util.Preconditions;

import flashbang.audio.AudioManager;
import flashbang.resource.ResourceManager;

public class Flashbang
{
    public static function get app () :FlashbangApp
    {
        return _app;
    }

    public static function get rsrcs () :ResourceManager
    {
        return _app._rsrcs;
    }

    public static function get audio () :AudioManager
    {
        return _app._audio;
    }

    internal static function registerApp (app :FlashbangApp) :void
    {
        Preconditions.checkState(_app == null, "A FlashbangApp has already been registered");
        _app = app;
    }

    protected static var _app :FlashbangApp;
}
}
