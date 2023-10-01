package ;

enum TaskType {
    Harvest;
}

class Task {
    public var type: TaskType;
    public var item: PlacedItem;
    public var isComplete = false;
    public var onProgress: () -> Void;

    public function new(type, item, onProgress: () -> Void) {
        this.type = type;
        this.item = item;
        this.onProgress = onProgress;
    }

    public function progress() {
        onProgress();
    }

    public function complete() {
        isComplete = true;
    }
}