extends Area2D

@export var item: InventoryItem

@onready var interaction_point: Marker2D = $InteractionPoint


func interact():
	if item == null:
		push_warning("Pickup has no InventoryItem assigned.")
		return

	InventoryManager.add_item(item)
	
	print("Picked up: ", item.display_name)

	GameUI.hide_hotspot_name()
	CursorManager.set_default_cursor()

	queue_free()


func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("left_click"):
		var player = get_tree().get_first_node_in_group("player")

		if player:
			player.move_to_interactable(self)


func _on_mouse_entered():
	if item == null:
		return

	CursorManager.set_interact_cursor()
	GameUI.show_hotspot_name(item.display_name)


func _on_mouse_exited():
	CursorManager.set_default_cursor()
	GameUI.hide_hotspot_name()
