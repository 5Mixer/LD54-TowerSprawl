package ;

import kha.Assets;
import kha.Framebuffer;

class PlayState extends State {
    var map: TileMap = new TileMap();
    var rooms: Array<Room>;

    public function new() {
        super();
        rooms = RoomLoader.loadRooms(Assets.blobs.rooms_txt);
    }

    override public function render(framebuffer: Framebuffer) {
        var graphics = framebuffer.g2;
        graphics.begin();
        graphics.clear(kha.Color.Black);
        map.render(graphics);

        var roomIndex = 0;
        for (room in rooms) {
            room.render(graphics, roomIndex * 28, 10);
            roomIndex++;
        }

        graphics.end();
    }
}