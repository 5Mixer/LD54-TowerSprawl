package ;

import kha.Assets;
import kha.Framebuffer;

class PlayState extends State {
    var map: TileMap = new TileMap();
    var rooms: Array<Room>;

    public function new() {
        super();
        rooms = RoomLoader.loadRooms(Assets.blobs.rooms_txt);

        var originRoom = new PlacedRoom(rooms[1], new Pos(80, 50));
        originRoom.stamp(map);
        var placedRooms = [originRoom];

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
    }

    override public function render(framebuffer: Framebuffer) {
        var graphics = framebuffer.g2;
        graphics.begin();
        graphics.clear(kha.Color.fromBytes(122, 172, 187));
        map.render(graphics);

        graphics.end();
    }

    override public function update() {
        map.set(Math.floor(MouseState.pos.x / 8), Math.floor(MouseState.pos.y / 8), Tile.Wall);
    }
}