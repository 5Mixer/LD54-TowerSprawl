package ;

import kha.math.Vector2i;
import kha.System;
import kha.graphics2.Graphics;
using VectorExtension;

class PlacementBar {
    var position = new Vector2i();
    var rooms: Array<Room>;
    var contentPadding = 10;
    var interiorPadding = 10;
    var windowHeight = 16 * Game.TILE_SIZE + 10 * 2; // Max room height is 16 tiles
    var pickedUpItem: Selectable;
    var pickUpOffset: Vector2i;
    var map: TileMap;

    public function new(rooms: Array<Room>, map: TileMap) {
        this.rooms = rooms;
        this.map = map;
    }

    public function render(g: Graphics) {
        g.color = kha.Color.fromBytes(216, 227, 224);
        g.fillRect(position.x, position.y, getWidth(), getHeight());
        g.color = kha.Color.White;

        for (item in getContents()) {
            item.render(g);
        }

        if (pickedUpItem != null) {
            var mapPos = getPickedUpItemMapPos();
            var validPlacement = pickedUpItem.room.canBePlacedAtMap(map, mapPos.x, mapPos.y);
            g.color = validPlacement ? kha.Color.fromBytes(114, 224, 148, 200) : kha.Color.fromBytes(227, 91, 56, 200);
            pickedUpItem.room.render(g, mapPos.x, mapPos.y);
            g.color = kha.Color.White;
        }
    }

    public function getPickedUpItemMapPos() {
        if (pickedUpItem != null) {
            return new Vector2i(Math.round((MouseState.pos.x - pickUpOffset.x) / Game.TILE_SIZE), Math.round((MouseState.pos.y - pickUpOffset.y) / Game.TILE_SIZE));
        }
        return null;
    }

    public function update() {
        var contents = getContents();
        if (pickedUpItem == null && MouseState.leftButtonJustDown) {
            for (item in contents) {
                if (MouseState.pos.insideRectangle(item.pos, item.size)) {
                    onPickUp(item);
                }
            }
        }
        if (!MouseState.isLeftButtonDown) {
            if (pickedUpItem != null) {
                var mapPos = getPickedUpItemMapPos();
                if (pickedUpItem.room.canBePlacedAtMap(map, mapPos.x, mapPos.y)) {
                    pickedUpItem.room.stampOnMap(map, mapPos.x, mapPos.y);
                }
            }
            pickedUpItem = null;
        }
    }

    function onPickUp(item: Selectable) {
        pickUpOffset = new Vector2i(MouseState.pos.x - item.pos.x, MouseState.pos.y - item.pos.y);
        pickedUpItem = item;
        item.clickCallback();
    }

    public function getContents() {
        var contents = [];
        var x = contentPadding;
        var y = contentPadding;
        for (room in rooms) {
            var roomPixelWidth = room.maxWidth * Game.TILE_SIZE;
            var roomPixelHeight = room.maxHeight * Game.TILE_SIZE;
            var localX = x;
            var localY = y;

            contents.push(new Selectable(
                new Vector2i(localX, localY),
                new Vector2i(roomPixelWidth, roomPixelHeight),
                () -> { },
                (g) -> { room.render(g, Std.int(localX / Game.TILE_SIZE), Std.int(localY / Game.TILE_SIZE)); },
                room
            ));
            x += roomPixelWidth + interiorPadding;
        }
        return contents;
    }

    function getWidth() {
        return System.windowWidth();
    }
    function getHeight() {
        return windowHeight;
    }
}