//
// flashbang

package flashbang.util {

import react.Registration;

/**
 * Implements {@link Registration} and a linked-list style list.
 */
internal class Cons implements Registration, LinkedElement
{
    public var _next :Cons;
    public var _data :*;
    public var _owner :LinkedList;

    public function Cons (owner :LinkedList, data :*) {
        _owner = owner;
        _data = data;
    }

    public function get next () :LinkedElement {
        return _next;
    }

    public function get data () :* {
        return _data;
    }

    public function close () :void {
        // multiple disconnects are OK, we just NOOP after the first one
        if (_owner != null) {
            _owner.removeCons(this);
            _owner = null;
            this._data = null;
        }
    }

    public static function insertFront (head :Cons, cons :Cons) :Cons {
        if (head == null) {
            return cons;
        } else {
            cons._next = head;
            return cons;
        }
    }

    public static function insertBack (head :Cons, cons :Cons) :Cons {
        if (head == null) {
            return cons;
        } else {
            head._next = insertBack(head._next, cons);
            return head;
        }
    }

    public static function remove (head :Cons, cons :Cons) :Cons {
        if (head == null) {
            return head;
        } else if (head == cons) {
            return head._next;
        } else {
            head._next = remove(head._next, cons);
            return head;
        }
    }
}
}

