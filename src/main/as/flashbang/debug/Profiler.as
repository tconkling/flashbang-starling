//
// Flashbang

package flashbang.debug {

import flash.system.Capabilities;
import flash.utils.getTimer;

import aspire.util.Log;
import aspire.util.Map;
import aspire.util.Maps;

public class Profiler
{
    public static var ENABLED :Boolean = Capabilities.isDebugger;

    public static function resetAllTimers () :void
    {
        if (ENABLED) {
            _timers = Maps.newMapOf(String);
        }
    }

    public static function resetTimer (timerName :String) :void
    {
        if (ENABLED) {
            _timers.remove(timerName);
        }
    }

    public static function pushTimer (timerName :String) :void
    {
        if (ENABLED) {
            _runningTimerNames.push(startTimer(timerName));
        }
    }

    public static function popTimer () :void
    {
        if (ENABLED) {
            if (_runningTimerNames.length == 0) {
                log.warning("popTimer() called without a corresponding pushTimer()");
            } else {
                stopTimer(_runningTimerNames.pop());
            }
        }
    }

    public static function startTimer (timerName :String) :String
    {
        if (ENABLED) {
            var timer :PerfTimer = getTimer(timerName);
            timer.timesRun++;
            if (timer.curRunCount++ == 0) {
                timer.startTime = flash.utils.getTimer();
            }
        }

        return timerName;
    }

    public static function stopTimer (timerName :String) :void
    {
        if (ENABLED) {
            var timer :PerfTimer = getTimer(timerName);
            if (timer.curRunCount > 0) {
                if (--timer.curRunCount == 0) {
                    timer.totalTime += flash.utils.getTimer() - timer.startTime;
                }
            }
        }
    }

    public static function displayStats () :void
    {
        if (ENABLED) {
            log.debug(getStatsString());
        }
    }

    public static function getStatsString () :String
    {
        var stats :String = "";
        if (ENABLED) {
            stats += "Performance stats: \n";
            _timers.forEach(function (timerName :String, timer :PerfTimer) :void {
                stats += getPerformanceSummary(timerName) + "\n";
            });
        }

        return stats;
    }

    public static function getPerformanceSummary (timerName :String) :String
    {
        var summary :String = "";
        if (ENABLED) {
            var timer :PerfTimer = getTimer(timerName);
            if (timer != null) {
                summary = "* " + timerName +
                    "\n\tTimes run: " + timer.timesRun +
                    "\n\tTotal time: " + timer.totalTime +
                    "\n\tAvg time: " + timer.totalTime / timer.timesRun;
            };
        }
        return summary;
    }

    protected static function getTimer (timerName :String) :PerfTimer
    {
        var timer :PerfTimer = _timers.get(timerName);
        if (null == timer) {
            timer = new PerfTimer();
            _timers.put(timerName, timer);
        }

        return timer;
    }

    protected static var _runningTimerNames :Array = [];
    protected static var _timers :Map = Maps.newMapOf(String);
    protected static const log :Log = Log.getLog(Profiler);
}

}

class PerfTimer
{
    public var timesRun :int;
    public var curRunCount :int;
    public var totalTime :Number = 0;
    public var startTime :int;
}
