package ;

import kha.math.Vector2i;
import kha.math.Vector2;
import kha.input.Mouse;

class MouseState {
    public static var pos = new Vector2i();
    public static var isLeftButtonDown = false; 
    public static var isRightButtonDown = false; 
    public static var isMiddleButtonDown = false; 
    public static var leftButtonJustDown = false; 
    public static var rightButtonJustDown = false; 
    static var wasLeftButtonDown = false; 
    static var wasRightButtonDown = false;
    public static var delta = new Vector2();

    public static function setup() {
        Mouse.get().notify(onMouseDown, onMouseUp, onMouseMove);
    }

    public static function worldPos() {
        var vec = Camera.transformToWorldSpace(pos);
        return new Vector2i(Std.int(vec.x), Std.int(vec.y));
    }

    public static function update() {
        leftButtonJustDown = isLeftButtonDown && !wasLeftButtonDown;
        rightButtonJustDown = isRightButtonDown && !wasRightButtonDown;
        wasLeftButtonDown = isLeftButtonDown;
        wasRightButtonDown = isRightButtonDown;
        delta.x = 0;
        delta.y = 0;
    }

    static function onMouseDown(button: Int, x: Int, y: Int) {
        pos.x = x;
        pos.y = y;
        if (button == 0) isLeftButtonDown = true;
        if (button == 1) isRightButtonDown = true;
        if (button == 2) isMiddleButtonDown = true;
    }

    static function onMouseUp(button: Int, x: Int, y: Int) {
        pos.x = x;
        pos.y = y;
        
        if (button == 0) isLeftButtonDown = false;
        if (button == 1) isRightButtonDown = false;
        if (button == 2) isMiddleButtonDown = false;
    }

    static function onMouseMove(x: Int, y: Int, dx: Int, dy: Int) {
        delta.x = x - pos.x;
        delta.y = y - pos.y;
        pos.x = x;
        pos.y = y;
        // delta.x = dx;
        // delta.y = dy;
    }
}