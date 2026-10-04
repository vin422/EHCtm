extends Node

signal item_added(item: InventoryItem)
signal item_removed(item: InventoryItem)
signal inventory_changed


var items: Array[InventoryItem] = []


func add_item(item: InventoryItem):
	if item == null:
		return

	items.append(item)

	item_added.emit(item)
	inventory_changed.emit()


func remove_item(item_id: String):
	for item in items:
		if item.id == item_id:
			items.erase(item)

			item_removed.emit(item)
			inventory_changed.emit()

			return


func has_item(item_id: String) -> bool:
	for item in items:
		if item.id == item_id:
			return true

	return false


func get_item(item_id: String) -> InventoryItem:
	for item in items:
		if item.id == item_id:
			return item

	return null


func get_items() -> Array[InventoryItem]:
	return items
