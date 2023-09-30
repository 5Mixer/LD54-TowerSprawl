package ;

import Selectable.SelectableContents;
import kha.math.FastMatrix3;
import kha.math.FastMatrix4;
import kha.math.Vector2i;
import kha.Assets;
import kha.Framebuffer;
using GraphicsExtension;

class PlayState extends State {
    var map: TileMap = new TileMap();
    var rooms: Array<Room>;
    var placementBar: PlacementBar;
    var itemTypes: Array<ItemType> = [];
    var minions: Array<Minion> = [];

    public function new() {
        super();
        rooms = RoomLoader.loadRooms(Assets.blobs.rooms_txt);

        var originRoom = new PlacedRoom(rooms[1], new Vector2i(80, 50));
        originRoom.stamp(map);
        var placedRooms = [originRoom];

        itemTypes = [
            new ItemType("Bed",          new Vector2i(0, 3), new Vector2i(2, 1)),
            new ItemType("Occupied Bed", new Vector2i(0, 4), new Vector2i(2, 1)),
            new ItemType("Lamp",         new Vector2i(2, 4), new Vector2i(1, 1))
        ];

        var iterations = 1000;
        while (iterations-- > 0) {
            var parentRoom = placedRooms[Math.floor(Math.random() * placedRooms.length)];
            var childRoomTemplate = rooms[Math.floor(Math.random() * rooms.length)];
            var parentDoors = parentRoom.getDoorPositions();
            
            var parentDoor = parentDoors[Math.floor(Math.random() * parentDoors.length)];

            var possiblePlacements = childRoomTemplate.attachmentsToDoor(map, parentDoor.x, parentDoor.y);
            if (possiblePlacements.length > 0) {
                var placement = possiblePlacements[Math.floor(Math.random() * possiblePlacements.length)];
                var childRoom = new PlacedRoom(childRoomTemplate, placement);
                childRoom.stamp(map);
                
                placedRooms.push(childRoom);
            }
        }
        
        placementBar = new PlacementBar(rooms, itemTypes, map, onPlacement);
    }

    override public function render(framebuffer: Framebuffer) {
        var graphics = framebuffer.g2;
        graphics.begin();
        graphics.clear(kha.Color.fromBytes(122, 172, 187));
        Camera.transform(graphics);
        map.render(graphics);
        placementBar.render(graphics);
        var i = 0;
        for (item in itemTypes) {
            item.render(graphics, 80 + 24 * (i++), 640);
        }
        for (minion in minions) {
            minion.render(graphics);
            var path = map.pathfind(minion.pos, new Vector2i(Std.int(MouseState.worldPos().x / Game.TILE_SIZE), Std.int(MouseState.worldPos().y / Game.TILE_SIZE)));
            for (step in path) {
                graphics.drawTile(Tile.Debug, step.x, step.y);
            }
        }
        graphics.transformation = FastMatrix3.identity();

        graphics.end();
    }

    override public function update() {
        placementBar.update();
        for (minion in minions) minion.update();
    }

    function onPlacement(placed: SelectableContents, pos: Vector2i) {
        switch (placed) {
            case Room(room): {}
            case Item(item): {
                if (item.name == "Bed") {
                    minions.push(new Minion(pos));
                }
            }
        }
    }
}