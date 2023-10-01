package ;

import kha.math.Vector2i;

class PlacedRoom {
    var roomTemplate: Room;
    var pos: Vector2i;

    public function new(roomTemplate: Room, pos: Vector2i) {
        this.roomTemplate = roomTemplate;
        this.pos = pos;
    }

    public function stamp(map: TileMap, real = false) {
        roomTemplate.stampOnMap(map, pos.x, pos.y, real);
    }

    public function getDoorPositions() {
        return roomTemplate.getDoors().map(doorTile -> new Vector2i(pos.x + doorTile.x, pos.y + doorTile.y));
    }
}