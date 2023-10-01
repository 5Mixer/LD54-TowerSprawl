package ;

class Box extends PlacedItem {
    public var contents: Array<ItemType> = [];

    public function addItem(item: ItemType) {
        contents.push(item);
    }
}