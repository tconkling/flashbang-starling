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
import aspire.util.Log;
import aspire.util.Map;
import aspire.util.Maps;
import aspire.util.Preconditions;
import aspire.util.Set;
import aspire.util.Sets;

public class ResourceManager
{
    public function ResourceManager ()
    {
        registerDefaultFactories();
    }

    public function shutdown () :void
    {
        unloadAll();
    }

    public function registerDefaultFactories () :void
    {
        registerFactory("xml", XmlResource.createFactory());
        registerFactory("sound", SoundResource.createFactory());
    }

    public function registerFactory (resourceType :String, factory :ResourceFactory) :void
    {
        _factories.put(resourceType, factory);
    }

    public function getResource (resourceName :String) :*
    {
        return _resources.get(resourceName);
    }

    public function requireResource (resourceName :String, type :Class) :*
    {
        var rsrc :Resource = getResource(resourceName);
        Preconditions.checkNotNull(rsrc, "missing required resource", "name", resourceName);
        if (!(rsrc is type)) {
            // perform the check before calling Preconditions, to avoid an unneccessary call to
            // ClassUtil.getClass
            Preconditions.checkState(false, "required resource is the wrong type",
                "name", resourceName, "expectedType", type, "actualType", ClassUtil.getClass(rsrc));
        }
        return rsrc;
    }

    public function isResourceLoaded (name :String) :Boolean
    {
        return (null != getResource(name));
    }

    public function unloadAll () :void
    {
        for each (var rset :ResourceSet in _resourceSets.toArray()) {
            rset.unload();
        }
    }

    internal function createResource (type :String, name :String, loadParams :*) :Resource
    {
        var factory :ResourceFactory = _factories.get(type);
        if (factory == null) {
            throw new Error("Unrecognized resource type: '" + type + "'");
        }
        return factory.create(name, loadParams);
    }

    internal function addResources (resourceSet :ResourceSet) :void
    {
        var rsrc :Resource;
        var resources :Array = resourceSet.resources;
        // validate all resources before adding them
        for each (rsrc in resources) {
            Preconditions.checkArgument(getResource(rsrc.name) == null,
                "A resource named '" + rsrc.name + "' already exists");
        }

        for each (rsrc in resources) {
            _resources.put(rsrc.name, rsrc);
        }
        _resourceSets.add(resourceSet);
    }

    internal function removeResources (resourceSet :ResourceSet) :void
    {
        var removed :Boolean = _resourceSets.remove(resourceSet);
        Preconditions.checkState(removed, "ResourceSet was not loaded");

        for each (var rsrc :Resource in resourceSet.resources) {
            _resources.remove(rsrc.name);
        }
    }

    protected var _resources :Map = Maps.newMapOf(String); // Map<name, resource>
    protected var _resourceSets :Set = Sets.newSetOf(ResourceSet);

    protected var _factories :Map = Maps.newMapOf(String);

    protected static var log :Log = Log.getLog(ResourceManager);
}

}
