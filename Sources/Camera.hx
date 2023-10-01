package ;

import kha.math.FastVector2;
import kha.math.Vector2i;
import kha.graphics2.Graphics;
import kha.math.FastMatrix3;

class Camera {
    private function new() {}

    public static var position = new Vector2i();
    public static var scale = 3;

    public static function transform(g: Graphics) {
        g.transformation = getTransformation();
    }
    
    static function getTransformation() {
        position.x = Std.int(position.x/8)*8;
        position.y = Std.int(position.y/8)*8;
        return FastMatrix3.scale(scale, scale).multmat(FastMatrix3.translation(-position.x, -position.y));
    }

    public static function transformToWorldSpace(point: Vector2i) {
        return getTransformation().inverse().multvec(new FastVector2(point.x, point.y));
    }
    public static function transformFromWorldSpace(point: Vector2i) {
        return getTransformation().multvec(new FastVector2(point.x, point.y));
    }
}