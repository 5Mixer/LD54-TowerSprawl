package ;

import kha.math.Vector2i;

enum TaskType {
    Harvest;
    Collect;
    Build;
}

class Task {
    public var type: TaskType;
    public var locations: Array<Vector2i> = [];
    public var isComplete = false;
    public var onProgress: Minion -> Void;

    public function new(type, locations, onProgress: Minion -> Void) {
        this.type = type;
        this.locations = locations;
        this.onProgress = onProgress;
    }

    public function progress(minion: Minion) {
        onProgress(minion);
    }

    public function complete() {
        isComplete = true;
    }
}