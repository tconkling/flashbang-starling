//
// Flashbang

package flashbang.resource {

import aspire.util.Map;
import aspire.util.Maps;
import aspire.util.Preconditions;

public class ResourceManager
{
    public function ResourceManager () {
        registerDefaultLoaders();
    }

    public function dispose () :void {
        unloadAll();
        _resources = null;
        _loaderClasses = null;
    }

    public function registerDefaultLoaders () :void {
        registerResourceLoader("xml", XmlResourceLoader);
        registerResourceLoader("sound", SoundResourceLoader);
        registerResourceLoader("flump", FlumpLibraryLoader);
        registerResourceLoader("font", FontResourceLoader);
    }

    public function registerResourceLoader (resourceType :String, loaderClass :Class) :void {
        _loaderClasses.put(resourceType, loaderClass);
    }

    public function getResource (resourceName :String) :* {
        return _resources.get(resourceName);
    }

    public function requireResource (resourceName :String) :* {
        var rsrc :Resource = getResource(resourceName);
        Preconditions.checkNotNull(rsrc, "missing required resource", "name", resourceName);
        return rsrc;
    }

    public function isResourceLoaded (name :String) :Boolean {
        return (null != getResource(name));
    }

    public function unloadAll () :void {
        _resources.forEach(function (name :String, rsrc :Resource) :void {
            rsrc.disposeInternal();
        });
        _resources = Maps.newMapOf(String);
    }

    internal function createLoader (loadParams :Object) :ResourceLoader {
        var type :String = loadParams["type"];
        Preconditions.checkArgument(type != null, "'type' must be specified");

        var clazz :Class = _loaderClasses.get(type);
        Preconditions.checkNotNull(clazz, "Unrecognized resource type", "type", type);

        var loader :ResourceLoader = new clazz(loadParams);
        return loader;
    }

    internal function addSet (resourceSet :ResourceSet, resources :Vector.<Resource>) :void {
        var rsrc :Resource;
        // validate all resources before adding them
        for each (rsrc in resources) {
            Preconditions.checkArgument(getResource(rsrc.name) == null,
                "A resource named '" + rsrc.name + "' already exists");
        }

        for each (rsrc in resources) {
            rsrc.addedInternal(resourceSet);
            _resources.put(rsrc.name, rsrc);
        }
    }

    internal function unloadSet (resourceSet :ResourceSet) :void {
        for each (var rsrc :Resource in _resources.values()) {
            if (rsrc._set == resourceSet) {
                _resources.remove(rsrc.name);
                rsrc.disposeInternal();
            }
        }
    }

    protected var _resources :Map = Maps.newMapOf(String); // Map<name, resource>
    protected var _loaderClasses :Map = Maps.newMapOf(String);
}

}
