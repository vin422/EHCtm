extends Node

signal item_added(item: InventoryItem)
signal item_removed(item: InventoryItem)
signal inventory_changed


var items: Array[InventoryItem] = []

var selected_item: InventoryItem = null

signal selection_changed(item: InventoryItem)


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

func select_item(item: InventoryItem):
	if item == null:
		return

	selected_item = item
	selection_changed.emit(selected_item)


func clear_selection():
	selected_item = null
	selection_changed.emit(null)


func get_selected_item() -> InventoryItem:
	return selected_item

func has_selected_item() -> bool:
	return selected_item != null


func use_selected_item_on(target):
	if selected_item == null:
		return

	if target.has_method("use_item"):
		target.use_item(selected_item)
