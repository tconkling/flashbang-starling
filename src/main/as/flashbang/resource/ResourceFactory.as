//
// flashbang

package flashbang.resource {

public interface ResourceFactory
{
    function create (name :String, params :Object) :Resource;
}
}
