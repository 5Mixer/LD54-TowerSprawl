package;

import kha.math.Vector2i;

class Game {
    private function new() {}
    public static final TILE_SIZE = 8;
    public static final PREVIEW_TILE_SIZE = 2;
    public static final VALID_TINT = kha.Color.fromBytes(114, 224, 148, 200);
    public static final INVALID_TINT = kha.Color.fromBytes(227, 91, 56, 200);
    public static final ITEM_TYPES = [
        ItemType.Bed => new ItemDefinition(Bed, new Vector2i(0, 3), new Vector2i(2, 1), true,
            function isBedLocationSuitable(where, map) {
                return
                    map.get(where.x, where.y+1) == Wall && map.get(where.x+1, where.y+1) == Wall && // Space below bed must be wall
                    map.get(where.x, where.y-1) == Interior && map.get(where.x+1, where.y-1) == Interior; // Space above bed must be interior
            }),
        ItemType.Lamp => new ItemDefinition(Lamp, new Vector2i(2, 4), new Vector2i(1, 1), true),
        ItemType.Mushroom => new ItemDefinition(Mushroom, new Vector2i(0, 6), new Vector2i(1, 1), true),
        ItemType.Box => new ItemDefinition(Box, new Vector2i(0, 9), new Vector2i(1, 1), true,
            function isBoxLocationSuitable(where, map) {
                return
                    map.get(where.x, where.y+1) == Wall && // Space below box must be wall
                    map.get(where.x, where.y-1) == Interior; // Space above box must be interior
            }),
        ItemType.Machine => new ItemDefinition(Machine, new Vector2i(0, 10), new Vector2i(3, 2), true,
            function isMachineLocationSuitable(where, map) {
                return
                    map.get(where.x, where.y+2) == Wall && // Space below box must be wall
                    map.get(where.x+1, where.y+2) == Wall &&
                    map.get(where.x+2, where.y+2) == Wall;
            }),
        ItemType.Wall => new ItemDefinition(Wall, new Vector2i(1, 0), new Vector2i(1, 1), false)
        
    ];
}