//
// aciv

package flashbang.util {

import flash.utils.Dictionary;

import react.NumberValue;
import react.NumberView;

/** Measures the progress of multiple Processes */
public class BatchProcess implements Process {
    public function add (process :Process) :void {
        _children[process] = 0;
        _totalSize += process.processSize;

        process.progress.connect(function (progress :Number) :void {
            _children[process] = progress;
            updateTotalProgress();
        });
    }

    public function get processSize () :Number {
        return _totalSize;
    }

    public function get progress () :NumberView {
        return _totalProgress;
    }

    private function updateTotalProgress () :void {
        var totalProgress :Number = 0;
        for (var process :Process in _children) {
            var thisProgress :Number = _children[process];
            totalProgress += (thisProgress * process.processSize);
        }

        _totalProgress.value = totalProgress / _totalSize;
    }

    private var _children :Dictionary = new Dictionary();
    private var _totalSize :Number = 0;
    private var _totalProgress :NumberValue = new NumberValue(0);
}
}
