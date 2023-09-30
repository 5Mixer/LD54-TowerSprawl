package ;

class PlacedRoom {
    var roomTemplate: Room;
    var pos: Pos;

    public function new(roomTemplate: Room, pos: Pos) {
        this.roomTemplate = roomTemplate;
        this.pos = pos;
    }

    public function stamp(map: TileMap) {
        roomTemplate.stampOnMap(map, pos.x, pos.y);
    }

    public function getDoorPositions() {
        return roomTemplate.getDoors().map(doorTile -> new Pos(pos.x + doorTile.x, pos.y + doorTile.y));
    }
}