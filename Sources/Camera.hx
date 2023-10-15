package ;

import kha.math.FastVector2;
import kha.math.Vector2i;
import kha.math.Vector2;
import kha.graphics2.Graphics;
import kha.math.FastMatrix3;
import kha.input.KeyCode;

class Camera {
    private function new() {}

    public static var position = new Vector2();
    public static var scale = 3;
    public static var panSpeed = 6;

    public static function transform(g: Graphics) {
        g.transformation = getTransformation();
    }
    
    static function getTransformation() {
        var roundedPosition = new Vector2i(Std.int(position.x), Std.int(position.y));
        return FastMatrix3.scale(scale, scale).multmat(FastMatrix3.translation(-roundedPosition.x, -roundedPosition.y));
    }

    public static function transformToWorldSpace(point: Vector2i) {
        return getTransformation().inverse().multvec(new FastVector2(point.x, point.y));
    }
    public static function transformFromWorldSpace(point: Vector2i) {
        return getTransformation().multvec(new FastVector2(point.x, point.y));
    }

    public static function panWithInput() {
        if (MouseState.isMiddleButtonDown) {
            Camera.position.x -= MouseState.delta.x / 2;
            Camera.position.y -= MouseState.delta.y / 2;
        }

        var down = KeyboardState.pressedButtons;
        var keyboardPan = new Vector2();
        if (down.contains(KeyCode.Left)  || down.contains(KeyCode.A)) keyboardPan.x -= 1;
        if (down.contains(KeyCode.Right) || down.contains(KeyCode.D)) keyboardPan.x += 1;
        if (down.contains(KeyCode.Up)    || down.contains(KeyCode.W)) keyboardPan.y -= 1;
        if (down.contains(KeyCode.Down)  || down.contains(KeyCode.S)) keyboardPan.y += 1;
        keyboardPan = keyboardPan.normalized().mult(panSpeed); // Normalise so that diagonal movement isn't faster
        position = position.add(keyboardPan);
    }
}