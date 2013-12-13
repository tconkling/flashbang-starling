//
// flashbang

package flashbang.util {

import aspire.util.F;
import aspire.util.Log;

import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import flashbang.core.FlashbangConfig;

import react.MultiFailureError;

public class ErrorScreen extends Sprite
{
    public function ErrorScreen (config :FlashbangConfig, error :*) {
        _error = error;
        _config = config;

        logError(error);
        addEventListener(Event.ADDED_TO_STAGE, once(F.bind(drawScreen)));
    }

    protected function drawScreen () :void {
        this.graphics.beginFill(0x0, 1);
        this.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
        this.graphics.endFill();

        var scrollSprite :Sprite = new Sprite();
        addChild(scrollSprite);

        var tf :TextField = new TextField();
        tf.width = this.stage.stageWidth - (MARGIN * 2);
        tf.height = this.stage.stageHeight - (MARGIN * 2);
        tf.multiline = true;
        tf.wordWrap = true;
        tf.selectable = true;
        tf.mouseEnabled = true;

        var format :TextFormat = new TextFormat();
        format.font = "_typewriter";
        format.size = 14;
        format.align = TextFormatAlign.LEFT;
        format.color = 0x00ff00;
        tf.defaultTextFormat = format;

        var errText :String = Errors.getMessage(_error);
        if (_config.buildId != null) {
            errText = "Build ID: " + _config.buildId + "\n" + errText;
        }
        tf.text = errText;

        tf.x = MARGIN;
        tf.y = MARGIN;
        scrollSprite.addChild(tf);
    }

    protected static function logError (error :*) :void {
        if (error is MultiFailureError) {
            for each (var child :Error in MultiFailureError(error).failures) {
                logError(child);
            }
        } else {
            log.error(Errors.getMessage(error));
        }
    }

    protected static function once (handler :Function) :Function {
        return function listener (event :Event) :void {
            event.currentTarget.removeEventListener(event.type, listener);
            handler(event);
        }
    }

    protected var _config :FlashbangConfig;
    protected var _error :*;

    protected static const MARGIN :Number = 5;

    protected static const log :Log = Log.getLog(ErrorScreen);
}
}
