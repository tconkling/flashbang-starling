//
// aciv

package flashbang.util {

import aspire.util.F;
import aspire.util.Joiner;
import aspire.util.Preconditions;

import react.Executor;
import react.Future;
import react.NumberValue;
import react.NumberView;
import react.Promise;

/** Runs multiple processes together and observes their aggregate progress */
public class BatchProcess implements Process, HasProcessSize {
    /** Runs 0 or more processes in a batch. Only creates a new BatchProcess if necessary. */
    public static function runBatch (processes :Array, exec :Executor = null) :Process {
        var process :Process;

        if (processes.length == 0) {
            return new CompletedProcess();
        } else if (processes.length == 1) {
            process = processes[0];
            if (exec != null) {
                exec.submit(process.begin);
            } else {
                process.begin();
            }
            return process;
        } else {
            var batch :BatchProcess = new BatchProcess().executor(exec);
            for each (process in processes) {
                batch.add(process);
            }
            batch.begin();
            return batch;
        }
    }

    /** Assigns an Executor for the BatchProcess to use to run sub-processes. */
    public function executor (exec :Executor) :BatchProcess {
        Preconditions.checkState(!_began, "Already running");
        _exec = exec;
        return this;
    }

    public function add (process :Process) :BatchProcess {
        Preconditions.checkState(!_began, "Already running");
        Preconditions.checkNotNull(process);

        var size :Number = (process is HasProcessSize ? HasProcessSize(process).processSize : 1);
        var subProcess :SubProcess = new SubProcess(process, size);
        _children[_children.length] = subProcess;
        _totalSize += size;

        return this;
    }

    /** @return Future<Array> containing the results of all sub-processes */
    public function get result () :Future {
        return _result;
    }

    public function get processSize () :Number {
        return _totalSize;
    }

    public function get progress () :NumberView {
        return _totalProgress;
    }

    public function begin () :Future {
        if (!_began) {
            _began = true;
            var futures :Array = [];
            for each (var subProcess :SubProcess in _children) {
                var processResult :Future = _exec == null ?
                    beginSubprocess(subProcess) :
                    _exec.submit(F.bind(beginSubprocess, subProcess));
                futures[futures.length] = processResult;
            }

            Future.sequence(futures).onSuccess(_result.succeed).onFailure(_result.fail);
        }

        return _result;
    }

    private function beginSubprocess (subProcess :SubProcess) :Future {
        try {
            var result :Future = subProcess.process.begin();
            subProcess.process.progress.connect(function (progress :Number) :void {
                subProcess.progress = progress;
                updateProgress();
            });
            return result;
        } catch (e :Error) {
            return Future.failure(Joiner.pairs("BatchProcess.beginSubprocess failed", "process", subProcess.process, e));
        }
    }

    private function updateProgress () :void {
        var totalProgress :Number = 0;
        _totalSize = 0;
        for each (var subProcess :SubProcess in _children) {
            var thisSize :Number = subProcess.size;
            _totalSize += thisSize;
            totalProgress += (subProcess.progress * thisSize);
        }

        _totalProgress.value = (_totalSize > 0 ? totalProgress / _totalSize : 0);
    }

    private const _result :Promise = new Promise();
    private const _totalProgress :NumberValue = new NumberValue(0);

    private var _exec :Executor;
    private var _children :Vector.<SubProcess> = new <SubProcess>[];
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
