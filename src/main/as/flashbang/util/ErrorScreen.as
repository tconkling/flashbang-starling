//
// flashbang

package flashbang.util {

import aspire.util.Log;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.ErrorEvent;
import flash.text.TextField;
import flash.text.TextFormat;

import flashx.textLayout.formats.TextAlign;

import react.MultiFailureError;

public class ErrorScreen
{
    public static function display (stage :Stage, error :*) :void {
        logError(error);
        // prevent multiple error screens
        if (_displaying) {
            return;
        }
        _displaying = true;

        var screen :Sprite = new Sprite();
        screen.graphics.beginFill(0x0, 1);
        screen.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
        screen.graphics.endFill();

        var scrollSprite :Sprite = new Sprite();
        screen.addChild(scrollSprite);

        var tf :TextField = new TextField();
        tf.width = stage.stageWidth - (MARGIN * 2);
        tf.height = stage.stageHeight - (MARGIN * 2);
        tf.multiline = true;
        tf.wordWrap = true;
        tf.selectable = true;
        tf.mouseEnabled = true;

        var format :TextFormat = new TextFormat();
        format.font = "_typewriter";
        format.size = 14;
        format.align = TextAlign.LEFT;
        format.color = 0x00ff00;
        tf.defaultTextFormat = format;

        tf.text = getErrorMessage(error);

        tf.x = MARGIN;
        tf.y = MARGIN;
        scrollSprite.addChild(tf);

        stage.addChild(screen);
    }

    protected static function getErrorMessage (error :*) :String {
        if (error is Error) {
            return Error(error).message;
        } else if (error is ErrorEvent) {
            return ErrorEvent(error).text;
        } else {
            return "" + error;
        }
    }

    protected static function logError (error :*) :void {
        if (error is MultiFailureError) {
            for each (var child :Error in MultiFailureError(error).failures) {
                logError(child);
            }
        } else if (error is Error) {
            log.error("", Error(error).getStackTrace());
        } else if (error is ErrorEvent) {
            log.error(ErrorEvent(error).toString());
        } else {
            log.error("An unknown error occurred", "error", error);
        }
    }

    protected static var _displaying :Boolean;

    protected static const MARGIN :Number = 5;

    protected static const log :Log = Log.getLog(ErrorScreen);
}
}
