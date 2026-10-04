extends CanvasLayer

@onready var hotspot_label: Label = $HotspotLabel
@onready var pocket_button: TextureButton = $InventoryUI/PocketButton
@onready var inventory_content: VBoxContainer = $InventoryUI/InventoryContent
@onready var slots: HBoxContainer = $InventoryUI/InventoryContent/Slots
@onready var description_label: Label = $InventoryUI/InventoryContent/DescriptionLabel

var hotspot_label_tween: Tween


func _ready():
	hotspot_label.hide()

	InventoryManager.inventory_changed.connect(refresh_inventory)
	InventoryManager.selection_changed.connect(_on_inventory_selection_changed)

	pocket_button.pressed.connect(toggle_inventory)

	# Connect hover signals from all 7 inventory slots
	for slot in slots.get_children():
		slot.item_hovered.connect(_on_item_hovered)
		slot.item_unhovered.connect(_on_item_unhovered)

	inventory_content.hide()
	description_label.text = ""

	refresh_inventory()


func _process(_delta):
	if hotspot_label.visible:
		var mouse_position = get_viewport().get_mouse_position()
		var viewport_size = get_viewport().get_visible_rect().size

		var label_position = Vector2(
			mouse_position.x - hotspot_label.size.x / 2.0,
			mouse_position.y - hotspot_label.size.y - 15.0
		)

		label_position.x = clamp(
			label_position.x,
			10.0,
			viewport_size.x - hotspot_label.size.x - 10.0
		)

		label_position.y = clamp(
			label_position.y,
			10.0,
			viewport_size.y - hotspot_label.size.y - 10.0
		)

		hotspot_label.position = label_position


func show_hotspot_name(hotspot_name: String):
	if hotspot_label_tween:
		hotspot_label_tween.kill()

	hotspot_label.text = hotspot_name
	hotspot_label.modulate.a = 0.0
	hotspot_label.show()

	hotspot_label_tween = create_tween()

	hotspot_label_tween.tween_property(
		hotspot_label,
		"modulate:a",
		1.0,
		0.12
	)


func hide_hotspot_name():
	if hotspot_label_tween:
		hotspot_label_tween.kill()

	hotspot_label_tween = create_tween()

	hotspot_label_tween.tween_property(
		hotspot_label,
		"modulate:a",
		0.0,
		0.10
	)

	hotspot_label_tween.tween_callback(hotspot_label.hide)

func toggle_inventory():
	inventory_content.visible = not inventory_content.visible


func refresh_inventory():
	var slot_nodes = slots.get_children()
	var inventory_items = InventoryManager.get_items()
	var selected_item = InventoryManager.get_selected_item()

	for i in range(slot_nodes.size()):
		var slot = slot_nodes[i]

		if i < inventory_items.size():
			var item = inventory_items[i]

			slot.setup(item)
			slot.set_selected(item == selected_item)
		else:
			slot.clear_slot()

func _on_inventory_selection_changed(item: InventoryItem):
	if item == null:
		CursorManager.stop_carrying_item()
	else:
		CursorManager.carry_item(item)

	refresh_inventory()

func _on_item_hovered(item: InventoryItem):
	description_label.text = item.description


func _on_item_unhovered():
	description_label.text = ""
