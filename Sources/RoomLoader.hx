package ;

import kha.Blob;

class RoomLoader {
    private function new() {}

    public static function loadRooms(roomDefinitions: Blob) {
        return roomDefinitions
            .toString()
            .split("--\n")
            .map((str) -> new Room(str));
    }
}