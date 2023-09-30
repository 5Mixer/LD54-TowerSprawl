package ;

import kha.Framebuffer;

class PlayState extends State {
    var map: TileMap = new TileMap();

    public function new() {
        super();
    }

    override public function render(framebuffer: Framebuffer) {
        var graphics = framebuffer.g2;
        graphics.begin();
        graphics.clear(kha.Color.Black);
        map.render(graphics);
        graphics.end();
    }
}