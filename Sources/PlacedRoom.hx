package ;

import kha.math.Vector2i;

class PlacedRoom extends PlacedItem {
    var roomTemplate: Room;
    var pathfindTarget: Vector2i;

    public function new(roomTemplate: Room, pos: Vector2i, pathfindTarget: Vector2i = null) {
        super(null, pos);
        this.roomTemplate = roomTemplate;
        this.pathfindTarget = pathfindTarget;
    }

    public function stamp(map: TileMap, real = false) {
        roomTemplate.stampOnMap(map, pos.x, pos.y, real);
    }

    public function getDoorPositions() {
        return roomTemplate.getDoors().map(doorTile -> new Vector2i(pos.x + doorTile.x, pos.y + doorTile.y));
    }

    public function withPathfindingTarget(target: Vector2i) {
        return new PlacedRoom(roomTemplate, pos, target);
    }

    override public function getPathFindTarget() {
        return pathfindTarget;
    }
}