//
// flashbang

package flashbang.util {

import react.Registration;

/** A singly-linked list. */
public class LinkedList
{
    public function dispose () :void {
        for (var cons :Cons = _head; cons != null; cons = cons._next) {
            cons._data = null;
            cons._owner = null;
        }

        _head = null;
        _iterating = null;
        _pendingRuns = null;
    }

    public function pushFront (data :*) :Registration {
        return addCons(new Cons(this, data), true);
    }

    public function pushBack (data :*) :Registration {
        return addCons(new Cons(this, data), false);
    }

    public function get isIterating () :Boolean {
        return _head == ITERATING;
    }

    public function clear () :void {
        if (this.isIterating) {
            _pendingRuns = pend(_pendingRuns, new Runs(clear));
        } else {
            for (var cons :Cons = _head; cons != null; cons = cons._next) {
                cons._data = null;
                cons._owner = null;
            }
            _head = null;
        }
    }

    public function beginIteration () :LinkedElement {
        if (_head == ITERATING) {
            throw new Error("Initiated beginIteration while iterating");
        }
        _iterating = _head;
        _head = ITERATING;
        return _iterating;
    }

    public function endIteration () :void {
        // note that we're no longer dispatching
        if (_head != ITERATING) {
            throw new Error("Not iterating");
        }

        _head = _iterating;
        _iterating = null;

        // now remove listeners any queued for removing and add any queued for adding
        for (; _pendingRuns != null; _pendingRuns = _pendingRuns.next) {
            _pendingRuns.action();
        }
    }

    private function addCons (cons :Cons, atFront :Boolean) :Cons {
        if (this.isIterating) {
            _pendingRuns = pend(_pendingRuns, new Runs(function () :void {
                _head = (atFront ? Cons.insertFront(_head, cons) : Cons.insertBack(_head, cons));
            }));
        } else {
            _head = (atFront ? Cons.insertFront(_head, cons) : Cons.insertBack(_head, cons));
        }
        return cons;
    }

    internal function removeCons (cons :Cons) :void {
        if (this.isIterating) {
            _pendingRuns = pend(_pendingRuns, new Runs(function () :void {
                _head = Cons.remove(_head, cons);
            }));
        } else {
            _head = Cons.remove(_head, cons);
        }
    }

    private static function pend (head :Runs, action :Runs) :Runs {
        if (head == null) {
            return action;
        } else {
            head.next = pend(head.next, action);
            return head;
        }
    }

    private var _head :Cons;
    private var _iterating :Cons;
    private var _pendingRuns :Runs;

    private static const ITERATING :Cons = new Cons(null, null);
}
}

class Runs {
    public var next :Runs;
    public var action :Function;

    public function Runs (action :Function) {
        this.action = action;
    }
}
