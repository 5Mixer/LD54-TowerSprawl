package ;

import kha.math.FastVector2;
import kha.math.Vector2i;
import kha.math.Vector2;
import kha.graphics2.Graphics;
import kha.math.FastMatrix3;

class Camera {
    private function new() {}

    public static var position = new Vector2();
    public static var scale = 3;
    public static var panSpeed = 6;

    public static function transform(g: Graphics) {
        g.transformation = getTransformation();
    }
    
    static function getTransformation() {
        var roundedPosition = new Vector2i(Std.int(position.x/scale)*scale, Std.int(position.y/scale)*scale);
        return FastMatrix3.scale(scale, scale).multmat(FastMatrix3.translation(-roundedPosition.x, -roundedPosition.y));
    }

    public static function transformToWorldSpace(point: Vector2i) {
        return getTransformation().inverse().multvec(new FastVector2(point.x, point.y));
    }
    public static function transformFromWorldSpace(point: Vector2i) {
        return getTransformation().multvec(new FastVector2(point.x, point.y));
    }
}