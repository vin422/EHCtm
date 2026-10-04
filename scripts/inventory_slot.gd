extends Button

var item: InventoryItem = null

@onready var icon_texture: TextureRect = $Icon

signal item_hovered(item: InventoryItem)
signal item_unhovered


func _ready():
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func setup(new_item: InventoryItem):
	item = new_item

	icon_texture.texture = item.icon
	icon_texture.show()

	tooltip_text = item.display_name
	disabled = false


func clear_slot():
	item = null

	icon_texture.texture = null
	icon_texture.hide()

	tooltip_text = ""
	disabled = true
	
	set_selected(false)


func _on_pressed():
	if item == null:
		return

	if InventoryManager.get_selected_item() == item:
		InventoryManager.clear_selection()
		return

	InventoryManager.select_item(item)

func set_selected(is_selected: bool):
	if is_selected:
		modulate = Color(0.45, 0.45, 0.45, 1.0)
	else:
		modulate = Color.WHITE	

func _on_mouse_entered():
	if item == null:
		return

	item_hovered.emit(item)


func _on_mouse_exited():
	if item == null:
		return

	item_unhovered.emit()	
