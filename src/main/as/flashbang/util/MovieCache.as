//
// Flashbang

package flashbang.util {

import aspire.util.F;
import aspire.util.Log;
import aspire.util.Preconditions;

import flash.utils.Dictionary;

import flashbang.resource.MovieResource;

import flump.display.Movie;

import react.Registration;

public class MovieCache implements Registration
{
    public function getMovie (name :String) :CachedMovie {
        Preconditions.checkState(!_disposed, "disposed");

        var cache :SingleMovieCache = getCache(name);
        if (cache.rsrc == null) {
            // that movie doesn't exist
            log.warning("No such movie", "name", name);
            return null;
        }

        var movie :Movie = (cache.movies.length > 0 ? cache.movies.pop() : null);
        if (movie == null) {
            movie = cache.rsrc.create();
        } else {
            // reset properties
            movie.goTo(0);
            movie.x = movie.y = 0;
            movie.pivotX = movie.pivotY = 0;
            movie.scaleX = movie.scaleY = 1;
            movie.skewX = movie.skewY = 0;
            movie.rotation = 0;
            movie.alpha = 1;
            movie.clipRect = null;
        }

        return new CachedMovieImpl(movie, F.bind(releaseMovie, movie, name));
    }

    public function requireMovie (name :String) :CachedMovie {
        var cached :CachedMovie = getMovie(name);
        if (cached == null) {
            throw new Error("Missing required movie [name=" + name + "]");
        }
        return cached;
    }

    public function clear () :void {
        Preconditions.checkState(!_disposed, "disposed");
        for each (var cache :SingleMovieCache in _caches) {
            for each (var movie :Movie in cache.movies) {
                movie.dispose();
            }
        }
        _caches = new Dictionary();
    }

    public function close () :void {
        Preconditions.checkState(!_disposed, "disposed");
        clear();
        _disposed = true;
    }

    protected function getCache (name :String) :SingleMovieCache {
        var cache :SingleMovieCache = _caches[name];
        if (cache == null) {
            cache = new SingleMovieCache();
            cache.rsrc = MovieResource.get(name);
            _caches[name] = cache;
        }
        return cache;
    }

    protected function releaseMovie (movie :Movie, name :String) :void {
        if (_disposed) {
            movie.dispose();
            return;
        }
        var cache :SingleMovieCache = getCache(name);
        movie.removeFromParent(false);
        cache.movies.push(movie);
    }

    protected var _caches :Dictionary = new Dictionary();
    protected var _disposed :Boolean;

    protected static const log :Log = Log.getLog(MovieCache);
}
}

import flashbang.resource.MovieResource;
import flashbang.util.CachedMovie;

import flump.display.Movie;

class SingleMovieCache {
    public var rsrc :MovieResource;
    public var movies :Vector.<Movie> = new <Movie>[];
}

class CachedMovieImpl implements CachedMovie
{
    public function CachedMovieImpl (movie :Movie, releaseFn :Function) {
        _movie = movie;
        _releaseFn = releaseFn;
    }

    public function get movie () :Movie {
        return _movie;
    }

    public function release () :void {
        if (_releaseFn != null) {
            _releaseFn();
            _releaseFn = null;
        }
    }

    public function close () :void {
        release();
    }

    protected var _movie :Movie;
    protected var _releaseFn :Function;
}
