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

import aspire.util.ClassUtil;
import aspire.util.Joiner;
import aspire.util.StringUtil;

import flashbang.util.Loadable;

public class Resource extends Loadable
{
    public function Resource (name :String, params :Object)
    {
        _name = name;
        _params = params;
    }

    public function get name () :String
    {
        return _name;
    }

    protected function hasLoadParam (name :String) :Boolean
    {
        return _params.hasOwnProperty(name);
    }

    protected function getLoadParam (name :String, defaultValue :* = undefined) :*
    {
        return (hasLoadParam(name) ? _params[name] : defaultValue);
    }

    protected function requireLoadParam (name :String, type :Class) :*
    {
        if (!hasLoadParam(name)) {
            throw new Error("Missing required loadParam [name=" + name + "]");
        }
        var param :* = getLoadParam(name);
        if (!(param is type)) {
            throw new Error("Bad load param [name=" + name + " type=" + type + "]");
        }
        return param;
    }

    override protected function fail (e :Error) :void
    {
        super.fail(new Error(Joiner.pairs(ClassUtil.tinyClassName(this) + " load error",
            "name", _name, "params", StringUtil.simpleToString(_params),
            "err", e.message)));
    }

    protected var _name :String;
    protected var _params :Object;
}

}
