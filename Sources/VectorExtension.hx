package ;

import kha.math.Vector2i;

class VectorExtension {
    static public function insideRectangle(vector: Vector2i, pos: Vector2i, size: Vector2i) {
        return
            vector.x >= pos.x &&
            vector.y >= pos.y &&
            vector.x < pos.x + size.x &&
            vector.y < pos.y + size.y; 
    }
}