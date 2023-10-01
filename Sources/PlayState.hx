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
    var itemTypes: Array<ItemDefinition> = [];
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

        var originRoom = new PlacedRoom(rooms[1], new Vector2i(40, 30));
        originRoom.stamp(map, true);

        // constructLevel();
        
        placementBar = new PlacementBar(rooms, map, onPlacement);
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
            freeTasks = freeTasks.concat(item.getTasks());
        }

        // Every task should be assigned to the minion closest to it.
        // Can't just loop through tasks and assign nearest minion, as that task may be the furthest - eg:
        // T1 T2 T3            Minion
        // A simple loop pairs (T1, Minion) when (T3, Minion) is best.
        var freeMinions = minions.filter(minion ->
            minion.heldItem == null && // If they're carrying something, don't interrupt them, they need to put it down
            (!minion.state.match(Walking(RetrievingItem(ItemType.Mushroom)))) && // Hungry minions shouldn't be interrupted
            !(minion?.task?.type == Harvest && minion.food < minion.maxFood/2) && // Allow hungry minions to focus on harvesting
            (minion.state.match(Idle) || minion.state.match(Walking(_))) // Minions should be idle or walking (besides above case)
        );
        
        while (freeTasks.length > 0 && freeMinions.length > 0){
            var bestPair: { minion: Minion, task: Task } = null;
            var bestDistance = Math.POSITIVE_INFINITY;
            for (task in freeTasks) {
                for (minion in freeMinions) {
                    var path = map.pathfind(task.item.getPathFindTarget(), minion.mapPos);
                    if (path == null) continue;
                    var distance = path.length;

                    if (task.type != Harvest) {
                        distance += minion.maxFood - minion.food; // Bias minions towards harvesting, depending on their hunger
                    }

                    if (distance < bestDistance && distance > 0) {
                        bestDistance = distance;
                        bestPair = { minion: minion, task: task };
                    }
                }
            }
            if (bestPair != null) {
                bestPair.minion.task = bestPair.task;
                freeMinions.remove(bestPair.minion);
                freeTasks.remove(bestPair.task);
            } else {
                break;
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
                if (item.type == Bed) {
                    minions.push(new Minion(pos));
                }
            }
        }
    }
}