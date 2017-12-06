//
// aciv

package flashbang.util {

import react.Future;
import react.NumberValue;
import react.NumberView;

/** A process that's already completed */
public class CompletedProcess implements Process, HasProcessSize {
    public function CompletedProcess (result :* = null) {
        _result = Future.success(result);
    }

    public function get processSize () :Number {
        return 1;
    }

    public function get result () :Future {
        return _result;
    }

    public function get progress () :NumberView {
        return _progress;
    }

    public function begin () :Future {
        return _result;
    }

    private var _result :Future;
    private const _progress :NumberView = new NumberValue(1);
}
}
