// Flashbang - a framework for creating Flash games
// http://code.google.com/p/flashbang/
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
//
// Copyright 2008 Three Rings Design
//
// $Id: AudioChannel.as 4552 2008-06-01 00:29:45Z tim $

package flashbang.audio {

import flashbang.resource.SoundResource;

import flash.media.SoundChannel;

public class AudioChannel
{
    public function get isPlaying () :Boolean
    {
        return (null != sound);
    }

    public function get isPaused () :Boolean
    {
        return (null != sound && null == channel);
    }

    public function get audioControls () :AudioControls
    {
        return (null != controls ? controls : DUMMY_CONTROLS);
    }

    public function get debugDescription () :String
    {
        return "sound: '" + sound.resourceName + "' id: " + id;
    }

    // managed by AudioManager

    internal var id :int = -1;
    internal var completeHandler :Function;
    internal var controls :AudioControls;
    internal var sound :SoundResource;
    internal var channel :SoundChannel;
    internal var playPosition :Number;
    internal var startTime :int;
    internal var loopCount :int;

    internal static const DUMMY_CONTROLS :AudioControls = new AudioControls();
}

}
