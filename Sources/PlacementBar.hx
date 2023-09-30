package ;

import Selectable.SelectableContents;
import kha.math.Vector2i;
import kha.System;
import kha.graphics2.Graphics;
using VectorExtension;

class PlacementBar {
    var position = new Vector2i();
    var rooms: Array<Room>;
    var itemTypes: Array<ItemType>;
    var contentPadding = 2;
    var interiorPadding = 2;
    var windowHeight = 16 * Game.PREVIEW_TILE_SIZE + 3*Game.PREVIEW_TILE_SIZE; // Max room height is 16 tiles, plus padding
    var pickedUpItem: Selectable;
    var pickUpOffset: Vector2i;
    var map: TileMap;
    var onPlacementCallback: (placed: SelectableContents, pos: Vector2i) -> Void;

    public function new(rooms: Array<Room>, itemTypes: Array<ItemType>, map: TileMap, onPlacementCallback: (placed: SelectableContents, pos: Vector2i) -> Void) {
        this.rooms = rooms;
        this.itemTypes = itemTypes;
        this.map = map;
        this.onPlacementCallback = onPlacementCallback;
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

            switch(pickedUpItem.contents) {
                case Room(room): {
                    var validPlacement = room.canBePlacedAtMap(map, mapPos.x, mapPos.y);
                    g.color = validPlacement ? Game.VALID_TINT : Game.INVALID_TINT;
                    room.render(g, mapPos.x, mapPos.y);
                    g.color = kha.Color.White;
                }
                case Item(item): {
                    var validPlacement = item.canBePlacedAtMap(map, mapPos.x, mapPos.y);
                    g.color = validPlacement ? Game.VALID_TINT : Game.INVALID_TINT;
                    item.render(g, mapPos.x, mapPos.y);
                    g.color = kha.Color.White;
                }
            }
            
        }
    }

    public function getPickedUpItemMapPos() {
        if (pickedUpItem != null) {
            return new Vector2i(Std.int((MouseState.worldPos().x/Game.TILE_SIZE) - pickUpOffset.x), Std.int((MouseState.worldPos().y/Game.TILE_SIZE) - pickUpOffset.y));
        }
        return null;
    }

    public function update() {
        var contents = getContents();
        if (pickedUpItem == null && MouseState.leftButtonJustDown) {
            for (item in contents) {
                if (MouseState.worldPos().insideRectangle(item.pos, item.size)) {
                    onPickUp(item);
                }
            }
        }
        if (!MouseState.isLeftButtonDown) {
            if (pickedUpItem != null) {
                var mapPos = getPickedUpItemMapPos();
                switch (pickedUpItem.contents) {
                    case Room(room): {
                        if (room.canBePlacedAtMap(map, mapPos.x, mapPos.y)) {
                            room.stampOnMap(map, mapPos.x, mapPos.y);
                        }
                    }
                    case Item(item): {
                        if (item.canBePlacedAtMap(map, mapPos.x, mapPos.y)) {
                            map.addItem(new PlacedItem(item, mapPos));
                        }
                    }
                }
                onPlacementCallback(pickedUpItem.contents, mapPos);
            }
            pickedUpItem = null;
        }
    }

    function onPickUp(item: Selectable) {
        pickUpOffset = new Vector2i(MouseState.worldPos().x - item.pos.x, MouseState.worldPos().y - item.pos.y);
        switch (item.contents) {
            case Room(_): pickUpOffset = pickUpOffset.div(Game.PREVIEW_TILE_SIZE);
            case Item(_): pickUpOffset = pickUpOffset.div(Game.TILE_SIZE);
        }
        pickedUpItem = item;
        item.clickCallback();
    }

    public function getContents() {
        var contents = [];
        var x = contentPadding;
        var y = contentPadding;
        for (room in rooms) {
            var xCopy = x;
            contents.push(new Selectable(
                new Vector2i(x, y),
                new Vector2i(room.maxWidth * Game.PREVIEW_TILE_SIZE, room.maxHeight * Game.PREVIEW_TILE_SIZE),
                () -> { },
                (g) -> { room.renderSmall(g, xCopy, y); },
                SelectableContents.Room(room)
            ));
            x += room.maxWidth * Game.PREVIEW_TILE_SIZE + interiorPadding;
        }

        x += 10; // Arbitrary padding between rooms and items...

        for (item in itemTypes) {
            var xCopy = x;

            contents.push(new Selectable(
                new Vector2i(x, y),
                new Vector2i(item.spriteSheetSize.x * Game.TILE_SIZE, item.spriteSheetSize.y * Game.TILE_SIZE),
                () -> {},
                (g) -> { item.render(g, Std.int(xCopy/Game.TILE_SIZE), Std.int(y/Game.TILE_SIZE)); },
                SelectableContents.Item(item)
            ));

            x += item.spriteSheetSize.x * Game.TILE_SIZE;
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