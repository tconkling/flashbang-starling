//
// Flashbang

package flashbang.resource {

import aspire.util.Preconditions;

import flash.utils.Dictionary;

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
        registerResourceLoader("sound", SoundResourceLoader);
        registerResourceLoader("flump", FlumpResourceLoader);
        registerResourceLoader("font", FontResourceLoader);
    }

    public function registerResourceLoader (resourceType :String, loaderClass :Class) :void {
        _loaderClasses[resourceType] = loaderClass;
    }

    public function getResource (resourceName :String) :* {
        return _resources[resourceName];
    }

    public function requireResource (resourceName :String) :* {
        var rsrc :Resource = _resources[resourceName];
        if (rsrc == null) {
            throw new Error("Missing required resource [name=" + resourceName + "]");
        }
        return rsrc;
    }

    public function isResourceLoaded (name :String) :Boolean {
        return name in _resources;
    }

    /** @return a list of all loaded Resources. The returned list is a view and is safe to modify. */
    public function getAll () :Vector.<Resource> {
        var all :Vector.<Resource> = new <Resource>[];
        for each (var rsrc :Resource in _resources) {
            all[all.length] = rsrc;
        }
        return all;
    }

    public function unloadAll () :void {
        for each (var rsrc :Resource in _resources) {
            rsrc.disposeInternal();
        }
        _resources = new Dictionary();
    }

    internal function createLoader (loadParams :Object) :ResourceLoader {
        var type :String = loadParams["type"];
        Preconditions.checkArgument(type != null, "'type' must be specified");

        var clazz :Class = _loaderClasses[type];
        Preconditions.checkNotNull(clazz, "Unrecognized resource type", "type", type);

        var loader :ResourceLoader = new clazz(loadParams);
        return loader;
    }

    internal function addSet (resourceSet :ResourceSet, resources :Vector.<Resource>) :void {
        var rsrc :Resource;
        // validate all resources before adding them
        for each (rsrc in resources) {
            if (isResourceLoaded(rsrc.name)) {
                throw new Error("A resource named '" + rsrc.name + "' already exists");
            }
        }

        for each (rsrc in resources) {
            rsrc.addedInternal(resourceSet);
            _resources[rsrc.name] = rsrc;
        }
    }

    internal function unloadSet (resourceSet :ResourceSet) :void {
        for each (var rsrc :Resource in _resources) {
            if (rsrc._set == resourceSet) {
                delete _resources[rsrc.name];
                rsrc.disposeInternal();
            }
        }
    }

    protected var _resources :Dictionary = new Dictionary(); // <name, resource>
    protected var _loaderClasses :Dictionary = new Dictionary(); // <name, Class>
}

}
