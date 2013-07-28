//
// flashbang

package flashbang.core {

internal interface GameObjectContainer
{
    /**
     * Adds a GameObject to the container. The GameObject must not be owned by another container.
     */
    function addObject (obj :GameObjectBase) :GameObjectRef;

    /**
     * Adds a GameObject to the container with the given name. If the container has other
     * objects with the same name, they won't be affected.
     */
    function addNamedObject (name :String, obj :GameObjectBase) :GameObjectRef;

    /**
     * Adds a GameObject to the container with the given name, removing all other objects
     * with the same name.
     */
    function replaceNamedObject (name :String, obj :GameObjectBase) :GameObjectRef;

    /**
     * Returns the first object with the given name in this container,
     * or null if no such object exists.
     */
    function getNamedObject (name :String) :GameObjectBase;

    /** Returns true if the container has at least one object with the given name */
    function hasNamedObject (name :String) :Boolean;

    /**
     * Removes the given object from the container.
     * An error will be thrown if the object does not belong to this container.
     */
    function removeObject (obj :GameObjectBase) :void;

    /** Removes all objects with the given name from the container. */
    function removeNamedObjects (name :String) :void;

    function get isLiveObject () :Boolean;
}
}
