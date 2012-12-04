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

package flashbang.resource {

import aspire.util.Log;

import flashbang.Flashbang;
import flashbang.util.Loadable;
import flashbang.util.LoadableBatch;

public class ResourceSet extends LoadableBatch
{
    public function ResourceSet (loadInSequence :Boolean = false)
    {
        super(loadInSequence);
    }

    public function addResource (type :String, name: String, loadParams :*) :void
    {
        addLoadable(Flashbang.rsrcs.createResource(type, name, loadParams));
    }

    override protected function succeed (result :* = undefined) :void
    {
        Flashbang.rsrcs.addResources(this);
        super.succeed(result);
    }

    override protected function doUnload () :void
    {
        super.doUnload();
        Flashbang.rsrcs.removeResources(this);
    }

    internal function get resources () :Array
    {
        return _loadedObjects.filter(function (l :Loadable, ..._) :Boolean {
            return l is Resource;
        });
    }

    protected static const log :Log = Log.getLog(ResourceSet);
}

}
