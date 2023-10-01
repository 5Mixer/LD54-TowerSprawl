package ;

enum TaskType {
    Harvest;
}

class Task {
    public var type: TaskType;
    public var item: PlacedItem;
    public var isComplete = false;
    public var onProgress: Minion -> Void;

    public function new(type, item, onProgress: Minion -> Void) {
        this.type = type;
        this.item = item;
        this.onProgress = onProgress;
    }

    public function progress(minion: Minion) {
        onProgress(minion);
    }

    public function complete() {
        isComplete = true;
    }
}