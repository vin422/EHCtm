extends Area2D

@export var interaction_name: String = "Object"
@export_multiline var description: String = "Nothing interesting here."

@onready var interaction_point: Marker2D = $InteractionPoint


func interact():
	print("Interacted with: ", interaction_name)
	print(description)


func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("left_click"):
		var player = get_tree().get_first_node_in_group("player")

		if player:
			player.move_to_interactable(self)

func _on_mouse_entered():
	CursorManager.set_interact_cursor()
	GameUI.show_hotspot_name(interaction_name)


func _on_mouse_exited():
	CursorManager.set_default_cursor()
	GameUI.hide_hotspot_name()
