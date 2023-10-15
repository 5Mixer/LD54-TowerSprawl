package ;

import kha.input.KeyCode;
import kha.math.Vector2i;
import kha.math.Vector2;
import kha.input.Keyboard;

class KeyboardState {
    public static var pressedButtons: Array<KeyCode> = []; 

    public static function setup() {
        Keyboard.get().notify(onKeyDown, onKeyUp);
    }

    static function onKeyDown(keyCode: KeyCode) {
        if (!pressedButtons.contains(keyCode))
            pressedButtons.push(keyCode);
    }

    static function onKeyUp(keyCode: KeyCode) {
        pressedButtons.remove(keyCode);
    }
}