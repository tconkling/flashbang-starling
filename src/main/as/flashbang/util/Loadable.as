//
// Flashbang - a framework for creating Flash games
// Copyright (C) 2008-2012 Three Rings Design, Inc., All Rights Reserved
// http://github.com/threerings/flashbang
//
// This library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this library.  If not, see <http://www.gnu.org/licenses/>.

package flashbang.util {

import aspire.util.Log;

public class Loadable
{
    public function load (onLoaded :Function = null, onLoadErr :Function = null) :void
    {
        if (_loaded && onLoaded != null) {
            onLoaded();

        } else if (!_loaded) {
            if (onLoaded != null) {
                _onLoadedCallbacks.push(onLoaded);
            }
            if (onLoadErr != null) {
                _onLoadErrCallbacks.push(onLoadErr);
            }

            if (!_loading) {
                _loading = true;
                doLoad();
            }
        }
    }

    public function unload () :void
    {
        if (_loading) {
            onLoadCanceled();
        }

        _loaded = false;
        _loading = false;
        _onLoadedCallbacks = [];
        _onLoadErrCallbacks = [];

        doUnload();
    }

    public function get isLoaded () :Boolean
    {
        return _loaded;
    }

    protected function onLoaded () :void
    {
        var callbacks :Array = _onLoadedCallbacks;

        _onLoadedCallbacks = [];
        _onLoadErrCallbacks = [];
        _loaded = true;
        _loading = false;

        for each (var callback :Function in callbacks) {
            callback();
        }
    }

    protected function onLoadErr (err :String) :void
    {
        var callbacks :Array = _onLoadErrCallbacks;
        unload();
        for each (var callback :Function in callbacks) {
            callback(err);
        }
    }

    /**
     * Subclasses may override this to respond to the canceling of an in-progress load.
     */
    protected function onLoadCanceled () :void
    {
    }

    /**
     * Subclasses must override this to perform the load.
     * If the load is successful, this function should call onLoaded(), otherwise it should
     * call onLoadErr().
     */
    protected function doLoad () :void
    {
        throw new Error("abstract");
    }

    /**
     * Subclasses must override this to perform the unload.
     */
    protected function doUnload () :void
    {
        throw new Error("abstract");
    }

    protected var _onLoadedCallbacks :Array = [];
    protected var _onLoadErrCallbacks :Array = [];
    protected var _loading :Boolean;
    protected var _loaded :Boolean;

    protected static const log :Log = Log.getLog(Loadable);
}

}
