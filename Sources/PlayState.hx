package ;

import kha.Color;
import kha.Image;
import haxe.io.Bytes;
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
    var tick = 0;
    var timeOfDay = 0;
    var dayTime = true;
    var skyImage: Image;
    var skyImageBytes: Bytes;

    public function new() {
        super();
        rooms = RoomLoader.loadRooms(Assets.blobs.rooms_txt);

        var originRoom = new PlacedRoom(rooms[1], new Vector2i(80, 50));
        originRoom.stamp(map);
        var placedRooms = [originRoom];

        skyImage = Image.createRenderTarget(256, 1);
        skyImage.g2.begin();
        skyImage.g2.drawSubImage(Assets.images.spritesheet, 0, 0, 0, 5 * Game.TILE_SIZE, 256, 1);
        skyImage.g2.end();
        #if kha_html5
        skyImageBytes = skyImage.getPixels();
        #end

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
        var g = framebuffer.g2;
        var pixelOffset = (Std.int(tick/10)%256);
        #if kha_html5
        var skyColour = Color.fromBytes(skyImageBytes.get(pixelOffset*4), skyImageBytes.get(pixelOffset*4+1), skyImageBytes.get(pixelOffset*4+2));
        #else
        var skyColour = skyImage.at(pixelOffset, 0);
        #end
        g.begin(true, skyColour);

        Camera.transform(g);

        map.render(g);
        placementBar.render(g);
        for (minion in minions) minion.render(g);

        g.transformation = FastMatrix3.identity();
        g.end();
    }

    override public function update() {
        placementBar.update();
        for (minion in minions) minion.update(map);

        timeOfDay = Std.int(tick/10) % 256;
        var previouslyDayTime = dayTime;
        dayTime = timeOfDay > 8 * Game.TILE_SIZE && timeOfDay < 31 * Game.TILE_SIZE;
        if (previouslyDayTime != dayTime) {
            var cursorMapPos = new Vector2i(Std.int(MouseState.worldPos().x / Game.TILE_SIZE), Std.int(MouseState.worldPos().y / Game.TILE_SIZE));
            switch(dayTime) {
                case true: for (minion in minions) minion.state = Walking(Working(cursorMapPos));
                case false: for (minion in minions) minion.state = Walking(Sleep);
            }
        }

        tick++;
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