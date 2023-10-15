package ;

import kha.graphics2.Graphics;
import kha.math.Vector2i;

class PlacedRoom {
    var roomTemplate: Room;
    var scaffoldWalls: Array<Vector2i> = [];
    var map: TileMap;
    var pos: Vector2i;

    public function new(roomTemplate: Room, pos: Vector2i, map: TileMap) {
        this.pos = pos;
        this.roomTemplate = roomTemplate;
        this.map = map;

        scaffoldWalls = roomTemplate.tiles
            .filter(tile -> tile.tile == Tile.Wall)
            .map(tile -> new Vector2i(tile.x + pos.x, tile.y + pos.y))
            .filter(wallPosition -> map.get(wallPosition.x, wallPosition.y, true) != Wall);
    }

    public function stamp(map: TileMap, real = false) {
        roomTemplate.stampOnMap(map, pos.x, pos.y, real);
    }

    public function build(map: TileMap) {
        if (scaffoldWalls.length <= 0) {
            return;
        }
        var newWallPosition = scaffoldWalls.pop();
        map.set(newWallPosition.x, newWallPosition.y, Wall, true);
        if (scaffoldWalls.length == 0) {
            stamp(map, true); // Place remaining room features, such as the interior.
        }
    }

    public function getTasks() {
        if (scaffoldWalls.length <= 0) {
            return [];
        }

        var buildTasks = [];
        buildTasks.push(new Task(
            Build,
            getDoorPositions(),
            (minion) -> {
                minion.heldItem = null;
                build(map);
                minion.task.complete();
            }
        ));
        return buildTasks;
    }

    public function getDoorPositions() {
        return roomTemplate.getDoors().map(doorTile -> new Vector2i(pos.x + doorTile.x, pos.y + doorTile.y));
    }
}
