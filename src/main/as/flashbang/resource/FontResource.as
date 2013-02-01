//
// flashbang

package flashbang.resource {
import starling.text.BitmapFont;
import starling.text.TextField;

import aspire.util.Preconditions;

public class FontResource extends Resource
{
    public function FontResource (name :String, font :BitmapFont) {
        super(name);

        // ResourceManager should prevent this from ever happening
        Preconditions.checkState(TextField.getBitmapFont(name) == null,
            "A font with this name somehow already exists");

        TextField.registerBitmapFont(font, name);
    }

    override protected function unload () :void {
        TextField.unregisterBitmapFont(_name, /*dispose=*/true);
    }
}
}
