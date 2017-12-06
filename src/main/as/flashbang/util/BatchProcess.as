//
// aciv

package flashbang.util {

import flash.utils.Dictionary;

import react.NumberValue;
import react.NumberView;

/** Measures the progress of multiple Processes */
public class BatchProcess implements Process {
    public function add (process :Process, size :Number = 1) :void {
        var subProcess :SubProcess = new SubProcess(process, size);
        _children[subProcess] = true;
        _totalSize += size;

        process.progress.connect(function (progress :Number) :void {
            subProcess.progress = progress;
            updateTotalProgress();
        });
    }

    public function get totalSize () :Number {
        return _totalSize;
    }

    public function get progress () :NumberView {
        return _totalProgress;
    }

    private function updateTotalProgress () :void {
        var totalProgress :Number = 0;
        for (var subProcess :SubProcess in _children) {
            totalProgress += (subProcess.progress * subProcess.size);
        }

        _totalProgress.value = totalProgress / _totalSize;
    }

    private var _children :Dictionary = new Dictionary();
    private var _totalSize :Number = 0;
    private var _totalProgress :NumberValue = new NumberValue(0);
}
}

import flashbang.util.Process;

class SubProcess {
    public var process :Process;
    public var size :Number;
    public var progress :Number = 0;

    public function SubProcess (process :Process, size :Number) {
        this.process = process;
        this.size = size;
    }
}
