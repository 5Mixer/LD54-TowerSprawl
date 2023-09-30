package ;

import kha.math.Vector2i;
import kha.input.Mouse;

class MouseState {
    public static var pos = new Vector2i();
    public static var isLeftButtonDown = false; 
    public static var isRightButtonDown = false; 
    public static var leftButtonJustDown = false; 
    public static var rightButtonJustDown = false; 
    static var wasLeftButtonDown = false; 
    static var wasRightButtonDown = false; 

    public static function setup() {
        Mouse.get().notify(onMouseDown, onMouseUp, onMouseMove);
    }

    public static function update() {
        leftButtonJustDown = isLeftButtonDown && !wasLeftButtonDown;
        rightButtonJustDown = isRightButtonDown && !wasRightButtonDown;
        wasLeftButtonDown = isLeftButtonDown;
        wasRightButtonDown = isRightButtonDown;
    }

    static function onMouseDown(button: Int, x: Int, y: Int) {
        pos.x = x;
        pos.y = y;
        if (button == 0) isLeftButtonDown = true;
        if (button == 1) isRightButtonDown = true;
    }

    static function onMouseUp(button: Int, x: Int, y: Int) {
        pos.x = x;
        pos.y = y;
        
        if (button == 0) isLeftButtonDown = false;
        if (button == 1) isRightButtonDown = false;
    }

    static function onMouseMove(x: Int, y: Int, dx: Int, dy: Int) {
        pos.x = x;
        pos.y = y;
    }
}