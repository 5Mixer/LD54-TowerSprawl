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

        skyImage = createSkyImage();
        #if kha_html5
        skyImageBytes = skyImage.getPixels();
        #end
        
        itemTypes = [
            new ItemType("Bed",          new Vector2i(0, 3), new Vector2i(2, 1),
                function isBedLocationSuitable(where) {
                    return
                        map.get(where.x, where.y+1) == Wall && map.get(where.x+1, where.y+1) == Wall && // Space below bed must be wall
                        map.get(where.x, where.y-1) == Interior && map.get(where.x+1, where.y-1) == Interior; // Space above bed must be interior
                }),
            new ItemType("Lamp",         new Vector2i(2, 4), new Vector2i(1, 1)),
            new ItemType("Mushroom",     new Vector2i(0, 6), new Vector2i(1, 1)),
            new ItemType("Box",          new Vector2i(0, 9), new Vector2i(1, 1),
                function isBedLocationSuitable(where) {
                    return
                        map.get(where.x, where.y+1) == Wall && // Space below box must be wall
                        map.get(where.x, where.y-1) == Interior; // Space above box must be interior
                })
        ];

        constructLevel();
        
        placementBar = new PlacementBar(rooms, itemTypes, map, onPlacement);
    }

    function createSkyImage() {
        var skyImage = Image.createRenderTarget(256, 1);
        skyImage.g2.begin();
        skyImage.g2.drawSubImage(Assets.images.spritesheet, 0, 0, 0, 5 * Game.TILE_SIZE, 256, 1);
        skyImage.g2.end();
        return skyImage;
    }

    function constructLevel() {
        var originRoom = new PlacedRoom(rooms[1], new Vector2i(80, 50));
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

    function getTaskOwner(task: Task) {
        for (minion in minions) if (minion.task == task) return minion;
        return null;
    }

    override public function update() {
        placementBar.update();
        updateDayTime();
        assignMinionTasks();        

        for (minion in minions) minion.update(map);
        minions = minions.filter(minion -> minion.alive);
        for (item in map.getItems()) item.update();

        tick++;
    }

    function assignMinionTasks() {
        var freeTasks = [];
        
        for (item in map.getItems()) {
            freeTasks = freeTasks.concat(item.getTasks().filter((task) -> getTaskOwner(task) == null));
        }

        for (task in freeTasks) {
            var freeMinions = minions.filter((minion) -> minion.task == null);
            if (freeMinions.length == 0) break;

            var nearestMinion = null;
            var minDistance = Math.POSITIVE_INFINITY;
            for (minion in freeMinions) {
                var path = map.pathfind(task.item.pos, minion.mapPos);
                if (path == null) continue;
                var distance = path.length;
                if (distance < minDistance && distance > 0) {
                    minDistance = distance;
                    nearestMinion = minion;
                }
            }
            
            if (nearestMinion != null) {
                nearestMinion.task = task;
            }
        }
    }

    function updateDayTime() {
        timeOfDay = Std.int(tick/10) % 256;
        var previouslyDayTime = dayTime;
        dayTime = timeOfDay > 8 * Game.TILE_SIZE && timeOfDay < 31 * Game.TILE_SIZE;
        if (previouslyDayTime != dayTime) {
            var cursorMapPos = new Vector2i(Std.int(MouseState.worldPos().x / Game.TILE_SIZE), Std.int(MouseState.worldPos().y / Game.TILE_SIZE));
            switch(dayTime) {
                case true: {
                    for (minion in minions) {
                        if (minion.state == Sleep) {
                            minion.state = Idle;
                            minion.task = null;
                        }
                    }
                }
                case false: {
                    for (minion in minions) minion.state = Walking(Sleep);
                }
            }
        }
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