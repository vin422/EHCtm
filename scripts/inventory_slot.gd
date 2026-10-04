extends Button

var item: InventoryItem

@onready var icon_texture: TextureRect = $Icon


func _ready():
	pressed.connect(_on_pressed)


func setup(new_item: InventoryItem):
	item = new_item

	icon_texture.texture = item.icon
	tooltip_text = item.display_name


func _on_pressed():
	if item == null:
		return

	InventoryManager.select_item(item)
