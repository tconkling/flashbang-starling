//
// aciv

package flashbang.util {

import aspire.util.Preconditions;

import flash.utils.Dictionary;

import react.Executor;

import react.Future;

import react.NumberValue;
import react.NumberView;
import react.Promise;

/** Runs multiple processes together and observes their aggregate progress */
public class BatchProcess implements Process {
    /** Assigns an Executor for the BatchProcess to use to run sub-processes. */
    public function executor (exec :Executor) :BatchProcess {
        Preconditions.checkState(!_began, "Already running");
        _exec = exec;
        return this;
    }

    public function add (process :Process, size :Number = 1) :BatchProcess {
        Preconditions.checkState(!_began, "Already running");

        var subProcess :SubProcess = new SubProcess(process, size);
        _children[subProcess] = true;
        _totalSize += size;

        process.progress.connect(function (progress :Number) :void {
            subProcess.progress = progress;
            updateTotalProgress();
        });

        return this;
    }

    /** @return Future<Array> containing the results of all sub-processes */
    public function get result () :Future {
        return _result;
    }

    public function get totalSize () :Number {
        return _totalSize;
    }

    public function get progress () :NumberView {
        return _totalProgress;
    }

    public function begin () :Future {
        if (_began) {
            return _result;
        }

        var futures :Array = [];
        for (var subProcess :SubProcess in _children) {
            var processResult :Future = _exec != null ?
                _exec.submit(subProcess.process.begin) :
                subProcess.process.begin();
            futures[futures.length] = processResult;
        }

        Future.sequence(futures).onSuccess(_result.succeed).onFailure(_result.fail);
        return _result;
    }

    private function updateTotalProgress () :void {
        var totalProgress :Number = 0;
        for (var subProcess :SubProcess in _children) {
            totalProgress += (subProcess.progress * subProcess.size);
        }

        _totalProgress.value = totalProgress / _totalSize;
    }

    private const _result :Promise = new Promise();
    private const _totalProgress :NumberValue = new NumberValue(0);

    private var _exec :Executor;
    private var _children :Dictionary = new Dictionary();
    private var _totalSize :Number = 0;

    private var _began :Boolean;
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
